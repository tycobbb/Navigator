//
//  NAVRouter.m
//  NavigationRouter
//

#import "NAVRouter_Private.h"

@implementation NAVRouter

- (instancetype)init
{
    if(self = [super init]) {
        // allocate transition queue
        _transitionQueue = [NSMutableArray new];
        
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

# pragma mark - Transitions

- (void)transitionWithAttributes:(NAVAttributesBuilder *)attributes animated:(BOOL)isAnimated completion:(void (^)(void))completion
{
    // create the transition to enqueue
    NAVTransition *transition = [[NAVTransition alloc] initWithAttributesBuilder:attributes];
    transition.isAnimated = isAnimated;
    transition.completion = completion;
    transition.delegate   = self;
    
    // enqueue the transition, and then immediately dequeue it if possible
    self.transitionQueue.pushFront(transition);
    
    [self dequeueTransition];
}

- (void)dequeueTransition
{
    // can't dequeue if we're in the middle of an existing transition
    if(self.isTransitioning || !self.transitionQueue.count) {
        return;
    }
    
    NAVTransition *transition = self.transitionQueue.pop;
    self.currentTransition = nil;
    
    [transition startWithUrl:self.currentUrl];
}

# pragma mark - NAVTransitionDelegate

- (void)transitionDidComplete:(NAVTransition *)transition
{
    self.lastTransition = transition;
    self.currentTransition = nil;

    [self dequeueTransition];
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

# pragma mark - Accessors

- (NAVURL *)currentUrl
{
    return nil;
}

- (BOOL)isTransitioning
{
    return self.currentTransition != nil;
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
