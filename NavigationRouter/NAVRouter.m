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
        
        #ifdef NAVIGATOR_VIEW
        _factory = [self defaultFactory];
        #endif
        
        // update the router with its initial routes
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
    
    // otherwise, dequeue the next transition and start if from our current url
    NAVTransition *transition = self.transitionQueue.pop;
    self.currentTransition = nil;
    
    [transition startFromUrl:self.currentUrl];
}

# pragma mark - NAVTransitionDelegate

- (void)transition:(NAVTransition *)transition prepareUpdate:(NAVUpdate *)update
{
    // find the corresponding route
    NAVRoute *route = self.routes[update.element.key];
   
    // we can't proceeed without a route
    NAVAssert(route != nil, NAVExceptionNoRouteFound, @"No route found for element: %@", update.element.key);
    
    // allow the update to do its own internal preperation
    [update prepareWithRoute:route factory:self.factory];
}

- (void)transition:(NAVTransition *)transition performUpdate:(NAVUpdate *)update completion:(void (^)(BOOL))completion
{
    // allow the update to run itself with our updater
    [update performWithUpdater:self.updater completion:completion];
}

- (void)transitionDidComplete:(NAVTransition *)transition
{
    self.lastTransition = transition;
    self.currentTransition = nil;

    [self dequeueTransition];
}

# pragma mark - NAVAnimatorDelegate

- (void)animation:(NAVAnimation *)animation didUpdateIsVisible:(BOOL)isVisible
{
    
}

# pragma mark - Routing

- (void)updateRoutes:(void (^)(NAVRouteBuilder *))routingBlock
{
    NSParameterAssert(routingBlock);
   
    // create a route builder from the router's current route map and update it
    NAVRouteBuilder *routeBuilder = [[NAVRouteBuilder alloc] initWithRoutes:self.routes];
    routingBlock(routeBuilder);
    
    self.routes = routeBuilder.routes;
    
    // hook into any newly added animators
    for(NAVRoute *route in routeBuilder.addedRoutes) {
        // make sure we have an animator; this might modify the route destination
        NAVAnimation *animation = [self ensureAnimationForRoute:route];
        // we want to get animator callbacks so that we can keep ourselves in sync
        animation.delegate = self;
    }
}

//
// Helpers
//

- (NAVAnimation *)ensureAnimationForRoute:(NAVRoute *)route
{
    // we don't have one if the route doesn't use an animator
    if(!NAVRouteTypeIsAnimator(route.type)) {
        return nil;
    }
    // create the animator internally for any route type that require it
    else if(route.type == NAVRouteTypeModal) {
        route.destination = [[NAVAnimationModal alloc] initWithRoute:route];
    }
    
    return route.destination;
}

# pragma mark - Setters

- (void)setNavigationController:(UINavigationController *)navigationController
{
    // TODO: create default updater
    self.updater = nil;
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

# pragma mark - Utilities

void NAVAssert(BOOL condition, NSString *name, NSString *format, ...)
{
    if(condition) {
        return;
    }
    
    va_list args;
    va_start(args, format);
    
    NSString *reason = [[NSString alloc] initWithFormat:format arguments:args];
    [[NSException exceptionWithName:name reason:reason userInfo:nil] raise];
    
    va_end(args);
}

# pragma mark - Constants

NSString * const NAVExceptionNoRouteFound = @"router.no.route.found";
NSString * const NAVExceptionInvalidRoute = @"router.invalid.route";
