Navigator
=========

Navigator is a URL router for managing application state in iOS applications. Unlike existing solutions to this
problem that provide transitions using `key/:id -> view` mappings, Navigator diffs URLs into a sequence of updates
that generate the entire view stack and can perform any necessary animations. This provides for increased view controller
and animation modularity, and it eases the burden of implementing features like deep-linking or state-based analytics.

## Installation
You can install Navigator with [CocoaPods](http://cocoapods.org/).

```ruby
pod 'Navigator', '~> 0.5'
```

## Usage
There are two classes at the core of Navigator: `NAVRouter` and `NAVViewController`. A router declares mappings from string keys to view controller classes, and URLs composed of these keys push views onto the stack, present them modally, or execute arbitrary animations.

### URLs
Let's break down an example `NAVRouter` URL. Here's a URL for a television application that has a home screen, a show detail screen pushed on top of it, and video player modal presented over everything. Something like:
```
television://home/show::2?video=v
```
And the breakdown:
- **Scheme**: `television` is the router's scheme, and all URLs must have a scheme. 
- **Components**: `home` and `show` are the URL's components, and they corresponding to views on the navigation stack. In this case, `home` is the root view and `show` is the visible view. 
- **Data**: the `show` also has a data element, `2`. This can be any string, and in this case it's a numeric id. These are passed to the view before it's on screen so that it has time to prepare.
- **Parameters**: `video=v` is this URL's only parameter. Parameters are key-value pairs where the key is a view's key, and the value is the view's state. In this case the view is `video` and its state is `visible`.

### Implementing a Router
Declare a new NAVRouter subclass, and import `NAVRouter_Subclass.h` in your implementation. Your router subclass gains an implicit (and *not* thread-safe) shared instance that you can access using `+router`.

##### Scheme
First-and-foremost the router needs a scheme, and you can specify one by implementing `+scheme`.
```Objective-C
+ (NSString *)scheme
{
    return @"demoapp";
}
```

##### Routes
The router also needs some routes, and you can define its initial routes internally using `-routes:`.
```Objective-C
- (void)routes:(NAVRouteBuilder *)route
{
    route.to(@"red").controller(RedViewController.class);
    route.to(@"purple").controller(PurpleViewController.class).as(NAVRouteTypeModal);
}
```
This method is passed a `NAVRouteBuilder` instance that you can use to construct the routes. Generally routes are created `to` a string key and are given destination object, which in all of these cases is the view controller class (subclassing `NAVViewController`) passed to `controller`.

The specifics of route building are covered later. Routes can be added-to/removed-from the router at any time using `-updateRoutes:`.

### Implementing View Controllers
The router needs to create view controllers, and the controllers themselves define how they should be created. By default,
the view controller is created from a storyboard and storyboard ID.

If you're cool with this, then at a minimum specify the storyboard name using `+storyboardName`
```Objective-C
+ (NSString *)storyboardName
{
    return @"MainStoryboard";
}
```

The router will then try to create the view controller from this storyboard using the stringified version of the controller's class name as the default ID. To customize this behavior, override `+storyboardIdentifier`. Whatever you ID, make sure to specify it for each view controller in the "Identity Inspector" panel in IB.

If a controller needs completely custom instantiation, it can override `+instance` to short-circuit the storyboard-loading process:

```Objective-C
+ (instancetype)instance
{
    return [[self alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
}
```

### Hooking into the Navigation Stack
The last step required to get the router up-and-running is to assosciate it to a navigation controller. You can achieve this by setting it explicity:
```Objective-C
[DemoRouter router].navigationController = self.navigationController;
```
Alternatively, if the router has no navigation controller and you set its `delegate` to something that is either a UINavigationController or has a method `-navigationController`, the router will attempt to use that as its navigation controller.

### Transitioning
The router would be pretty useless if it couldn't move between views. Every router subclass you define gains an implicit (not thread-safe) shared instance method, `-router`. The router specifies one method for initiating transitions, `-transition`, that returns a builder to construct the transition. Let's break down some example transitions.

```Objective-C
[DemoRouter router].transition
  .root(@"red")
  .start(nil);
```
