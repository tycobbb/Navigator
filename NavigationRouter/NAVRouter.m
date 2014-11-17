//
//  NAVRouter.m
//  NavigationRouter
//

#import "NAVRouter_Private.h"

@implementation NAVRouter

- (instancetype)init
{
    if(self = [super init]) {
        // create an update builder that we can use to construct updates for transitions
        _updateBuilder = [NAVUpdateBuilder new];
        _updateBuilder.delegate = self;
        
        // update the router with it's initial routes
        [self updateRoutes:^(NAVRouteBuilder *route) {
            [self routes:route];
        }];
    }
    
    return self;
}

# pragma mark - Routing

- (void)updateRoutes:(void (^)(NAVRouteBuilder *))routingBlock
{
    NSParameterAssert(routingBlock);
   
    // create a route builder from the router's current route map and update it
    NAVRouteBuilder *routeBuilder = [[NAVRouteBuilder alloc] initWithRoutes:self.routes];
    routingBlock(routeBuilder);
    
    self.routes = routeBuilder.routes;
}

# pragma mark - Shared Instance

+ (instancetype)router
{
    NAVRouterPrototype *prototype = self.prototype;
    
    // create the shared instance if necessary
    if(!prototype.instance) {
        prototype.instance = [self new];
    }
    
    return prototype.instance;
}

char *prototypeKey;

+ (NAVRouterPrototype *)prototype
{
    // get the prototype assosciated with this class
    NAVRouterPrototype *prototype = objc_getAssociatedObject(self, prototypeKey);

    // create the prototype and assosciate it with this class if it doesn't exist
    if(!prototype) {
        prototype = [NAVRouterPrototype new];
        objc_setAssociatedObject(self, prototypeKey, prototype, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return prototype;
}

@end

@implementation NAVRouter (Subclass)

- (void)routes:(NAVRouteBuilder *)route { }

@end

@implementation NAVRouterPrototype @end
