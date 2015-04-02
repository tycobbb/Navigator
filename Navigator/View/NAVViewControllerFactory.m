//
//  NAVViewControllerFactory.m
//  Navigator
//

@import ObjectiveC;

#import "NAVViewControllerFactory_Private.h"
#import "NAVViewController.h"
#import "NAVRouter_Private.h"

@implementation NAVViewControllerFactory

+ (void)initialize
{
    [super initialize];
    
    [self swizzleDefaultFactory];
}

- (UIViewController *)controllerForRoute:(NAVRoute *)route
{
    // destination should be a controller class in this case
    Class<NAVViewController> klass = route.destination;
     
    NAVViewController *controller;
    
    // attempt to create the view controller; we're only catching exceptions here so that
    // we might throw something more informative
    @try {
        controller = [klass instance];
    }
    // if the storyboard doesn't contain this vc, throw a custom exception
    @catch(NSException *exception) {
        if([exception.name isEqualToString:NSInvalidArgumentException]) {
            exception = [self routingExceptionForRoute:route controllerClass:klass];
        }
        
        [exception raise];
    }
    
    return controller;
}

- (NAVAnimation *)animationForRoute:(NAVRoute *)route
{
    return route.type == NAVRouteTypeAnimation ? route.destination : nil;
}

//
// Exceptions
//

- (NSException *)routingExceptionForRoute:(NAVRoute *)route controllerClass:(Class<NAVViewController>)klass
{
    NSString *reason = [NSString stringWithFormat:@"%@.storyboard does not contain a view controller with id \"%@\" for route \"%@\"",
        [klass storyboardName], [klass storyboardIdentifier], route.path
    ];
    
    return [NSException exceptionWithName:NAVExceptionViewConfiguration reason:reason userInfo:nil];
}

# pragma mark - Swizzling

typedef id<NAVRouterFactory>(*NAVFactoryImp)(id, SEL);
// static storage for the unswizzled -defaulFactory
static NAVFactoryImp nav_original_defaultFactory;

+ (void)prepareToLaunch
{
    // no-op
}

+ (void)swizzleDefaultFactory
{
    // let's only swizzle once
    if(nav_original_defaultFactory) {
        return;
    }
    
    Method method = class_getInstanceMethod([NAVRouter class], @selector(defaultFactory));
    // store the original implementation
    nav_original_defaultFactory = (NAVFactoryImp)method_getImplementation(method);
    // and update it
    method_setImplementation(method, (IMP)nav_defaultFactory);
}

id<NAVRouterFactory> nav_defaultFactory(id self, SEL _cmd)
{
    // allow the original implementation to return something
    id<NAVRouterFactory> factory = nav_original_defaultFactory(self, _cmd);
    // otherwise, return a new NAVViewControllerFactory
    return factory ?: [NAVViewControllerFactory new];
}

@end
