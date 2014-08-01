//
//  NAVRouter.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRouter_Private.h"

@interface NAVRouter () <NAVUpdateBuilderDelegate>
@property (copy  , nonatomic) NSURL *currentURL;
@property (strong, nonatomic) NSDictionary *routes;
@property (strong, nonatomic) NAVTransaction *currentTransaction;
@property (strong, nonatomic) NAVTransaction *lastTransaction;
@property (strong, nonatomic) NAVUpdateBuilder *updateBuilder;
@property (strong, nonatomic) NSMutableDictionary *outstandingAnimators;
@end

@implementation NAVRouter

- (instancetype)initWithScheme:(NSString *)scheme
{
    NSParameterAssert(scheme);
    
    if(self = [super init])
    {
        _currentURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", scheme]];
        _parser     = [NAVURLParser new];
        _updateBuilder = [NAVUpdateBuilder new];
        _updateBuilder.delegate = self;
        _outstandingAnimators = [NSMutableDictionary new];
    }
    
    return self;
}

# pragma mark - Route Mapping

- (void)updateRoutes:(void(^)(NAVRouteBuilder *route))routingBlock
{
    if(!routingBlock)
        return;
    
    NAVRouteBuilder *routeBuilder = [[NAVRouteBuilder alloc] initWithRoutes:self.routes];
    routingBlock(routeBuilder);

    [self setRoutes:[routeBuilder.routes copy]];
}

# pragma mark - Transitions

- (void)transitionWithAttributes:(NAVAttributes *)attributes animated:(BOOL)isAnimated completion:(void(^)(void))completion
{
    NSAssert(self.factory, @"must have a factory to transition");
    NSAssert(self.updater, @"must have an updater to transition");
    
    NSError *error = nil;
    if(self.isTransitioning)
        error = [NSError nav_errorWithDescription:@"attempting to transition during an existing transition!"];
    if(!attributes.destinationURL)
        error = [NSError nav_errorWithDescription:@"attempting to transition without an URL, that's illegal"];
    
    if(![self check:error])
        return;
        
    NAVTransaction *transaction = [[NAVTransaction alloc] initWithAttributes:attributes scheme:self.scheme];
    transaction.isAnimated = isAnimated;
    transaction.completion = completion;

    [self executeTransaction:transaction];
}

- (void)executeTransaction:(NAVTransaction *)transaction
{
    self.currentTransaction = transaction;
    transaction.updates = [self updatesForTransaction:transaction];
    
    [self transaction:transaction performUpdateAtIndex:0 completion:^{
        self.currentURL = transaction.destinationURL;
        
        // capture the transactions completion block, and then nil it out so mark the transaction
        // as finished
        void(^transactionCompletion)(void) = self.currentTransaction.completion;
        self.currentTransaction.completion = nil;
        
        self.lastTransaction    = self.currentTransaction;
        self.currentTransaction = nil;
        
        // call the completion if if it exists, and we're done
        if(transactionCompletion)
            transactionCompletion();
    }];
}

//
// Accessors
//

- (BOOL)isTransitioning
{
    return self.currentTransaction != nil;
}

# pragma mark - Update Exection

- (void)transaction:(NAVTransaction *)transaction performUpdateAtIndex:(NSInteger)index completion:(void(^)(void))completion
{
    // if we're out of updates, then we can consider this transaction complete
    if(index >= transaction.updates.count)
        completion();
    else
    {
        // otherwise, we'll ask this update to perform itself, and then call this method recursively to iterate
        // through the list of updates
        
        NAVUpdate *currentUpdate = transaction.updates[index];
        [self performUpdate:currentUpdate withCompletion:^(BOOL finished) {
            [self transaction:transaction performUpdateAtIndex:index+1 completion:completion];
        }];
    }
}

- (void)performUpdate:(NAVUpdate *)update withCompletion:(void(^)(BOOL finished))completion
{
    [update performWithUpdater:self.updater completion:completion];
}

# pragma mark - NAVUpdateBuilderDelegate

- (NAVRoute *)builder:(NAVUpdateBuilder *)builder routeForKey:(NSString *)key
{
    return [self routeForKey:key];
}

- (UIViewController *)builder:(NAVUpdateBuilder *)builder controllerForUpdate:(NAVUpdate *)update
{
    return [self.factory controllerForRoute:update.route withAttributes:update.attributes];
}

- (NAVAnimator *)builder:(NAVUpdateBuilder *)builder animatorForUpdate:(NAVUpdateAnimation *)update
{
    NSString *animatorKey = update.route.path;
    
    // check to see if we have an animator for this route, which we should if this is a disable
    NAVAnimator *animator = self.outstandingAnimators[animatorKey];
    if(animator)
        return animator;
    
    // otherwise create an animator from the factory and add that to our store of active animators
    animator = [self createAnimatorForUpdate:update];
    
    self.outstandingAnimators[animatorKey] = animator;
    [animator onDismissal:^{
        [self.outstandingAnimators removeObjectForKey:animatorKey];
    }];
    
    return animator;
}

//
// Helpers
//

- (NAVAnimator *)createAnimatorForUpdate:(NAVUpdateAnimation *)update
{
    NAVAnimator *animator = [self.factory animatorForRoute:update.route withAttributes:update.attributes];
    if(animator || update.type != NAVUpdateTypeModal)
        return animator;
    
    NAVAnimatorModal *modalAnimator = [NAVAnimatorModal new];
    modalAnimator.viewController = [self builder:self.updateBuilder controllerForUpdate:update];
    return modalAnimator;
}

# pragma mark - Error Checking

- (BOOL)check:(NSError *)error
{
    if(!error)
        return YES;
    NAVLog(@"Nav.Router | Error(%d): %@", (int)error.code, error.localizedDescription);
    return NO;
}

# pragma mark - Setters

- (void)setDelegate:(id<NAVRouterDelegate>)delegate
{
    _delegate = delegate;
    
    if(self.updater)
        return;
    else if([delegate isKindOfClass:[UINavigationController class]])
        self.updater = [self buildUpdaterFromNavigationController:(UINavigationController *)delegate];
    else if([delegate respondsToSelector:@selector(navigationController)])
        self.updater = [self buildUpdaterFromNavigationController:[delegate performSelector:@selector(navigationController)]];
}

//
// Helpers
//

- (id<NAVRouterUpdater>)buildUpdaterFromNavigationController:(UINavigationController *)navigationController
{
    if([navigationController isKindOfClass:[UINavigationController class]])
        return [[NAVRouterNavigationControllerUpdater alloc] initWithNavigationController:navigationController];
    return nil;
}

# pragma mark - Accessors

- (NAVAttributesBuilder *)attributesBuilder
{
    return [[NAVAttributesBuilder alloc] initWithSourceURL:self.currentURL];
}

- (NSString *)scheme
{
    return self.currentURL.scheme;
}

- (NAVRoute *)routeForKey:(NSString *)key
{
    return self.routes[key];
}

- (BOOL)parameterIsEnabled:(NSString *)parameter
{
    return self.lastTransaction.destinationURL[parameter].isVisible;
}

@end

@implementation NAVRouter (Updates)

- (NSArray *)updatesForTransaction:(NAVTransaction *)transaction
{
    NAVURLTransitionComponents *components =
        [self.parser router:self transitionComponentsFromURL:transaction.sourceURL toURL:transaction.destinationURL];
    NSArray *updates = [self updatesForComponents:components attributes:transaction.attributes builder:self.updateBuilder];
    
    // if the transaction specifies unanimated, we'll override any default behavior established
    // during update creation
    for(NAVUpdate *update in updates)
        if(!transaction.isAnimated)
            update.isAnimated = NO;
    
    return updates;
}

- (NSArray *)updatesForComponents:(NAVURLTransitionComponents *)components attributes:(NAVAttributes *)attributes builder:(NAVUpdateBuilder *)update
{
    NAVURLComponent *component;
    
    NSMutableArray *updates = [NSMutableArray new];
    for(NAVURLParameter *parameter in components.parametersToDisable)
        [updates addObject:update.with.parameter(parameter).attributes(attributes).build];
    
    component = components.componentToReplace;
    if(component)
        [updates addObject:update.as(NAVUpdateTypeReplace).with.component(component).attributes(attributes).build];
    
    component = components.componentsToPop.firstObject;
    if(components.componentsToPop.count)
        [updates addObject:update.as(NAVUpdateTypePop).with.component(component).attributes(attributes).build];
    
    for(NAVURLComponent *component in components.componentsToPush)
        [updates addObject:update.as(NAVUpdateTypePush).with.component(component).attributes(attributes).build];
    
    for(NAVURLParameter *parameter in components.parametersToEnable)
        [updates addObject:update.with.parameter(parameter).attributes(attributes).build];
    
    return updates;
}

@end

# pragma mark - Strings

NSString * const NAVRouterDidUpdateURLNotification = @"NAVRouterDidUpdateURLNotification";
NSString * const NAVRouterNotificationURLKey       = @"NAVRouterNotificationURLKey";
