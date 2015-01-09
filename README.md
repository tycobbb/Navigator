Navigator
=========

Navigator is a URL router for tracking application state and transitioning between views. Unlike existing solutions to this
problem that provide isolated transitions using `key/:id -> view` mappings, Navigator diffs URLs into a sequence of updates
that can perform any number of stack changes and execute arbitrary animations. This provides for increased view controller
and animation modularity, and it eases the burden of implementing features like deep-linking or state-based analytics.

## Installation
You can install Navigator with [CocoaPods](http://cocoapods.org/).

```ruby
pod 'Navigator', '~> 0.3'
```

## Setup
There are two classes at the core of Navigator: `NAVRouter` and `NAVViewController`. A router declares mappings from string keys to view controller classes, and URLs composed of these keys push views onto the stack, present them modally, or execute arbitrary animations.

### URLs
Let's break down an example. Here's a URL for television application that has a home screen, a show detail screen pushed on top of it, and video player modal presented over everything. Something like:
```
television://home/show::2?video=v
```
And the breakdown:
- **Scheme**: `television` is the router's scheme, and all URLs must have a scheme. 
- **Components**: `home` and `show` are the URL's components, and they corresponding to views on the navigation stack. In this case, `home` is the root view and `show` is the visible view. 
- **Data**: the `show` also has a data element, `2`. This can be any string, and in this case it's a numeric id. These are passed to the view before it's on screen so that it has time to prepare.
- **Parameters**: `video=v` is this URL's only parameter. Parameters are key-value pairs where the key is a view's key, and the value is the view's state. In this case the view is `video` and its state is `visible`.

### Implementing a Router
Declare a new NAVRouter subclass, and import `NAVRouter_Subclass.h` in your implementation.

##### Scheme
First and foremost the router needs a scheme, and you can specify one by implementing `+scheme`:
```Objective-C
+ (NSString *)scheme
{
    return @"demoapp";
}
```

##### Routes
The router also needs some routes, and you can define its initial routes internally using `-routes:`:
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
The router needs to create view controllers, and the controllers themselves define how they should be created. By default, the router creates subclasses of NAVViewController from a storyboard and storyboard ID.

If you're cool with this, then at a minimum specify the storyboard name in your subclass using `+storyboardName`:
```Objective-C
+ (NSString *)storyboardName
{
    return @"MainStoryboard";
}
```

The router then tries to create the view controller from this storyboard using the stringified version of the controller's class name as the default ID. To customize this behavior, override `+storyboardIdentifier`. Whatever your ID, make sure to specify it for each view controller in the "Identity Inspector" panel in IB.

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

### Animations

Custom animations can be hooked into the router by subclassing `NAVAnimation` and creating a route with an instance of that animation. The actual view update is driven by `-updateIsVisible:animated:completion:`. The router will call this method as routing changes cause animation updates.

For instance, to implement a simple side-menu animation you could define the following class:
```Objective-C
@implementation MenuAnimation

- (void)updateIsVisible:(BOOL)isVisible animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    [UIView animateWithDuration:0.4f delay:0.0f usingSpringWithDamping:0.75f initialSpringVelocity:0.0f options:0 animations:^{
        self.animatingView.transform = CGAffineTransformMakeTranslation(isVisible ? 300.0f : 0.0f, 0.0f);
    } completion:completion];
}

@end
```

And then add a route to an instance of this animation to expose it:
```Objective-C
MenuAnimation *menuAnimation = [MenuAnimation new];
menuAnimation.animatingView  = self.containerView;

[[DemoRouter router] updateRoutes:(NAVRouteBuilder *route) {
    route.to(@"menu").animation(menuAnimation);
}];
```

If the animation needs to happen outside of the router, such as through an interactive gesture, it should also drive its logic through the `NAVAnimation` subclass. In this case, the animation should set the animation's `isVisible` property appropriately when the interaction completes.

## Usage
Your router subclass gains an implicit (and *not* thread-safe) shared instance that you can access using `+router`, which you can use to transition, update routes, etc.

### Transitioning
The router would be pretty useless if it couldn't move between views. It specifies one method for initiating transitions, `-transition`, that returns a flexible builder to construct and initiate a routing change. Let's break down some example transitions.

```Objective-C
[DemoRouter router].transition
    .root(@"red")
    .animated(NO)
    .start(nil);
```

This transitions the router to a new `root` view, mapped from `@"red"`, and throws away any other views on the stack. You'll probably do something like this when you first launch your app. 

The method `-start` finishes building and attempts to immediately run the transition. It accepts a completion block that is called when the transition finishes, or immediately with an error if there was already a running transition.

```Objective-C
[DemoRouter router].transition
    .push(@"green")
    .present(@"purple")
    .enqueue(nil).
```

Transitions can be composed from multiple URL changes. This transition pushes the `@"green"` view onto the stack, and then when it's finished presents the `@"purple"` view modally.

This method also uses `-enqueue` rather than `-start`, which waits until any running or queued transitions finish before resolving. If no such transitions exist, it starts immediately.

### Passing Data during Transitions

You can also pass data strings, objects (say for instance, models), and handlers during transitions that will be delievered to the view(s).

```Objective-C
[DemoRouter router].transition
    .push(@"red")
    .data(demoModel.identifier)
    .object(demoModel)
    .start(nil)
```

These are delievered to subclasses of `NAVViewController` or `NAVAnimation` via `-updateWithAttributes:`. This method is passed an instance of `NAVAttributes` that encapsulates the relevant transition data, and they are discarded aftewrads.

```Objective-C
- (void)updateWithAttributes:(NAVAttributes *)attributes
{
    [super updateWithAttributes:attributes];
    NSLog(@"%@: %@", attributes.data, attributes.userObject);
}
```

### Route Building

While initially defined inside a `NAVRouter` subclass' `-routes:` method, routes can can be changed at any time using `-updateRoutes:`. This method accepts a block that is passed a `NAVRouteBuilder` instance.

Routes can be configured with animations, controller classes, and custom types:
```Objective-C
[[DemoRouter router] updateRoutes:^(NAVRouteBuilder *route) {
    route.to(@"video").controller(VideoViewController.class).as(NAVRouteTypeModal);
    route.to(@"menu").animation(menuAnimation);
}];
```

If a route is passed a controller or animation, its type is implicitly `NAVRouteTypeStack` or `NAVRouteTypeAnimation` respectively. It can be further specified using `-as`, such as in the case of `NAVRouteTypeModal`. This allows view controllers to be presented, rather than pushed.
