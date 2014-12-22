//
//  NAVRouter.m
//  NavigationRouter
//

#import "NAVRouter_Private.h"

@implementation NAVRouter

- (instancetype)init
{
    if(self = [super init]) {
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

- (NAVTransitionBuilder *)transition
{
    NAVTransitionBuilder *transitionBuilder = [NAVTransition builder];
    transitionBuilder.delegate = self;
    return transitionBuilder;
}

- (void)dequeueTransition
{
    // can't dequeue if we're in the middle of an existing transition
    if(self.isTransitioning || !self.transitionQueue.count) {
        return;
    }
    
    // if we don't have a URL, create a default from our scheme
    NAVURL *currentUrl = self.currentUrl ?: [NAVURL URLWithPath:[NSString stringWithFormat:@"%@://", self.class.scheme]];
    
    // otherwise, build the next queued transition from our current url
    NAVTransitionBuilder *transitionBuilder = self.transitionQueue.pop;
    
    self.currentTransition = transitionBuilder.build(currentUrl);
    self.currentTransition.delegate = self;
    
    // and kick it off
    [self.currentTransition start];
}

//
// NAVTransitionBuilderDelegate
//

- (void)enqueueTransitionForBuilder:(NAVTransitionBuilder *)transitionBuilder
{
    if(transitionBuilder.shouldEnqueue || !self.isTransitioning) {
        self.transitionQueue.pushFront(transitionBuilder);
        // attempt to run the queued transition right away
        [self dequeueTransition]; 
    }
    // otherwise, this is an error case. we can't run a transition that isn't
    // enqueable if there's one running already
    else {
        NAVTransition *transition = transitionBuilder.build(self.currentUrl);
        
        // tell the transition to fail right away
        [transition failWithError:[NSError errorWithDomain:NAVRouterErrorDomain code:-1 userInfo:@{
            NSLocalizedDescriptionKey: @"Attempted to run an un-enqueuable transition during an existing transition."
        }]];
    }
}

# pragma mark - NAVTransitionDelegate

- (void)transitionWillStart:(NAVTransition *)transition
{
    if([self.delegate respondsToSelector:@selector(router:willPerformUpdates:)]) {
        [self.delegate router:self willPerformUpdates:self.currentTransition.updates];
    }
}

- (void)transition:(NAVTransition *)transition prepareUpdate:(NAVUpdate *)update
{
    // find the corresponding route
    NAVRoute *route = self.routes[update.element.key];
    NAVAssert(route != nil, NAVExceptionNoRouteFound, @"No route found for element: %@", update.element.key);
    
    // allow the update to do its own internal preperation
    [update prepareWithRoute:route factory:self.factory];
}

- (void)transition:(NAVTransition *)transition performUpdate:(NAVUpdate *)update completion:(void (^)(BOOL))completion
{
    if([self.delegate respondsToSelector:@selector(router:willPerformUpdate:)]) {
        [self.delegate router:self willPerformUpdate:update];
    }
    
    // allow the update to run itself with our updater
    [update performWithUpdater:self.updater completion:^(BOOL finished) {
        if([self.delegate respondsToSelector:@selector(router:didPerformUpdate:)]) {
            [self.delegate router:self didPerformUpdate:update];
        }
        
        completion(finished);
    }];
}

- (void)transitionDidComplete:(NAVTransition *)transition
{
    if([self.delegate respondsToSelector:@selector(router:didPerformUpdates:)]) {
        [self.delegate router:self didPerformUpdates:transition.updates];
    }
    
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
    
    for(NAVRoute *route in routeBuilder.addedRoutes) {
        // ensure we have an animation for any animated route; this may mutate the route destination
        NAVAnimation *animation = [self ensureAnimationForRoute:route];
        // make sure we get animation callbacks
        animation.delegate = self;
    }
}

//
// Helpers
//

- (NAVAnimation *)ensureAnimationForRoute:(NAVRoute *)route
{
    if(!NAVRouteTypeIsAnimator(route.type)) {
        return nil;
    }
    
    // create the animator internally for any route types that require it
    else if(route.type == NAVRouteTypeModal) {
        route.destination = [[NAVAnimationModal alloc] initWithRoute:route];
    }
    
    return route.destination;
}

# pragma mark - NAVAnimatorDelegate

- (void)animation:(NAVAnimation *)animation didUpdateIsVisible:(BOOL)isVisible
{
    // if we're transition, then we're assuming that animation happened within the router
    if(self.isTransitioning) {
        return;
    }
    
    // TODO: figure out what needs to happen here to stay in sync
}

# pragma mark - NAVNavigationControllerUpdater

- (void)setNavigationController:(UINavigationController *)navigationController
{
    self.updater = [self updaterFromNavigationController:navigationController];
}

- (NAVNavigationControllerUpdater *)updaterFromNavigationController:(UINavigationController *)navigationController
{
    NAVNavigationControllerUpdater *updater = [[NAVNavigationControllerUpdater alloc] initWithNavigationController:navigationController];
    updater.delegate = self;
    return updater;
}

//
// NAVNavigationControllerUpdaterDelegate
//

- (void)updater:(NAVNavigationControllerUpdater *)updater didUpdateViewControllers:(NSArray *)viewControllers
{
    // we only care if the nav controller seems to have popped view controllers without
    // our knowledge
    if(self.isTransitioning || viewControllers.count >= self.currentUrl.components.count) {
        return;
    }
    
    // set the last transition an unexecuted transition with the controller difference
    // poppeed off the url
    self.lastTransition = [NAVTransitionBuilder new]
        .pop(self.currentUrl.components.count - viewControllers.count)
        .build(self.currentUrl);
}

# pragma mark - Setters

- (void)setDelegate:(id<NAVRouterDelegate>)delegate
{
    _delegate = delegate;
    
    // if we don't have an updater, try and create one from our delegate
    if(!self.updater) {
        UINavigationController *navigationController = [self navigationControllerFromDelegate:delegate];
        // only create an updater if we can find a nav controller on our delegate
        if(navigationController) {
            self.updater = [self updaterFromNavigationController:navigationController];
        }
    }
}

- (UINavigationController *)navigationControllerFromDelegate:(id)delegate
{
    // see if our delegate is a nav controller
    if([delegate isKindOfClass:UINavigationController.class]) {
        return delegate;
    }
    
    // see if we can find a navigation controller on our delegate
    id navigationController = [delegate performSelector:@selector(navigationController)];
    if([navigationController isKindOfClass:UINavigationController.class]) {
        return navigationController;
    }
    
    // give up
    return nil;
}

# pragma mark - Accessors

- (NAVURL *)currentUrl
{
    return self.lastTransition.attributes.destination;
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

+ (NSString *)scheme
{
    NAVAssert(false, NAVExceptionNoScheme, @"The router needs a URL scheme to function"); return nil;
}

- (void)routes:(NAVRouteBuilder *)route
{

}

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

void optionally_dispatch_async(BOOL async, dispatch_queue_t queue, void(^block)(void))
{
    if(!async) {
        dispatch_sync(queue, block);
    }
    else {
        dispatch_async(queue, block);
    }
}

# pragma mark - Constants

NSString * const NAVRouterErrorDomain     = @"router.error";
NSString * const NAVExceptionNoScheme     = @"router.no.scheme";
NSString * const NAVExceptionNoRouteFound = @"router.no.route.found";
NSString * const NAVExceptionInvalidRoute = @"router.invalid.route";
