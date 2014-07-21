//
//  NAVRouter.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRouter_Private.h"

@interface NAVRouter ()
@property (copy  , nonatomic) NSURL *currentURL;
@property (strong, nonatomic) NSDictionary *routes;
@property (strong, nonatomic) NAVTransaction *currentTransaction;
@end

@implementation NAVRouter

- (instancetype)initWithScheme:(NSString *)scheme
{
    NSParameterAssert(scheme);
    
    if(self = [super init])
    {
        _currentURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", scheme]];
        _parser     = [NAVURLParser new];
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
    NSError *error = nil;
    if(self.isTransitioning)
        error = [NSError nav_errorWithDescription:@"attempting to transition during an existing transition!"];
    if(!attributes.sourceURL)
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
    transaction.updates = [self updatesFromURL:transaction.sourceURL toURL:transaction.destinationURL];
    
    [self transaction:transaction performUpdateAtIndex:0 completion:^{
        self.currentURL = transaction.destinationURL;
        
        void(^transactionCompletion)(void) = self.currentTransaction.completion;
        self.currentTransaction = nil;
        
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
    // if we're out of URLs, then we completed the stack. return the last update
    if(index >= transaction.updates.count)
    {
        completion();
        return;
    }
    
    NAVUpdate *currentUpdate = transaction.updates[index];
    
    // then we want to run this update and immediately kick off the next one
    if(currentUpdate.isAsynchronous)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self executeUpdate:currentUpdate withCompletion:nil];
        });
        [self transaction:transaction performUpdateAtIndex:index+1 completion:completion];
    }
    
    // otherwise, we want to perform this update and wait for it to complete
    else
    {
        [self executeUpdate:currentUpdate withCompletion:^(BOOL finished) {
            [self transaction:transaction performUpdateAtIndex:index+1 completion:completion];
        }];
    }
}

- (void)executeUpdate:(NAVUpdate *)update withCompletion:(void(^)(BOOL finished))completion
{
    [update executeWithUpdater:self.updater completion:completion];
}

# pragma mark - Error Checking

- (BOOL)check:(NSError *)error
{
    if(!error)
        return NO;
    NAVLog(@"Nav.Router | Error(%d): %@", error.code, error.localizedDescription);
    return YES;
}

# pragma mark - Accessors

- (Class)attributesClass
{
    return _attributesClass ?: [NAVAttributes class];
}

- (NSString *)scheme
{
    return self.currentURL.scheme;
}

- (NAVRoute *)routeForKey:(NSString *)key
{
    return self.routes[key];
}

@end

@implementation NAVRouter (Updates)

- (NSArray *)updatesFromURL:(NAVURL *)sourceURL toURL:(NAVURL *)destinationURL
{
    NAVURLTransitionComponents *components = [self.parser router:self transitionComponentsFromURL:sourceURL toURL:destinationURL];
    NSArray *updates = [self baseUpdatesFromTransitionComponents:components];
    
    for(NAVUpdate *update in updates)
        [update configureWithFactory:self.factory];
    
    return updates;
}

- (NSArray *)baseUpdatesFromTransitionComponents:(NAVURLTransitionComponents *)components
{
    NSMutableArray *updates = [NSMutableArray new];
    for(NAVURLParameter *parameter in components.parametersToDisable)
        [updates addObject:[self updateWithParameter:parameter]];
    
    if(components.componentToReplace)
        [updates addObject:[self updateWithType:NAVUpdateTypeReplace component:components.componentToReplace]];
    
    if(components.componentsToPop.count)
        [updates addObject:[self updateWithType:NAVUpdateTypePop component:components.componentsToPop.firstObject]];
    
    for(NAVURLComponent *component in components.componentsToPush)
        [updates addObject:[self updateWithType:NAVUpdateTypePush component:component]];
    
    for(NAVURLParameter *parameter in components.parametersToEnable)
        [updates addObject:[self updateWithParameter:parameter]];
    
    return updates;
}

- (NAVUpdate *)updateWithParameter:(NAVURLParameter *)parameter
{
    NAVRoute *route   = [self routeForKey:parameter.key];
    NAVUpdate *update = [NAVUpdate updateWithType:[self updateTypeForRoute:route] route:route];
    update.isAsynchronous = parameter.options & NAVParameterOptionsAsync;
    return update;
}

- (NAVUpdate *)updateWithType:(NAVUpdateType)type component:(NAVURLComponent *)component
{
    NAVRoute *route   = [self routeForKey:component.key];
    NAVUpdate *update = [NAVUpdate updateWithType:type route:route];
    return update;
}

//
// Helpers
//

- (NAVUpdateType)updateTypeForRoute:(NAVRoute *)route
{
    switch(route.type)
    {
        case NAVRouteTypeAnimation:
            return NAVUpdateTypeAnimation;
        case NAVRouteTypeModal:
            return NAVUpdateTypeModal;
        default:
            NSAssert(false, @"can't fully determine update type from this route"); return 0;
    }
}

@end

# pragma mark - Strings

NSString * const NAVRouterDidUpdateURLNotification = @"NAVRouterDidUpdateURLNotification";
NSString * const NAVRouterNotificationURLKey       = @"NAVRouterNotificationURLKey";

NSString * const NAVComponentsToReplaceKey  = @"NAVComponentsToReplaceKey";
NSString * const NAVComponentsToPushKey    = @"NAVComponentsToPushKey";
NSString * const NAVComponentsToPopKey     = @"NAVComponentsToPopKey";
NSString * const NAVParametersToEnableKey  = @"NAVParametersToEnableKey";
NSString * const NAVParametersToDisableKey = @"NAVParametersToDisableKey";
