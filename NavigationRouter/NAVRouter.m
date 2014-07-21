//
//  NAVRouter.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRouter_Private.h"

@interface NAVRouter () <NAVUpdateBuilderDelegate>
@property (copy  , nonatomic) NSURL *currentURL;
@property (strong, nonatomic) NSDictionary *routes;
@property (strong, nonatomic) NAVTransaction *currentTransaction;
@property (strong, nonatomic) NAVUpdateBuilder *builder;
@end

@implementation NAVRouter

- (instancetype)initWithScheme:(NSString *)scheme
{
    NSParameterAssert(scheme);
    
    if(self = [super init])
    {
        _currentURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", scheme]];
        _parser     = [NAVURLParser new];
        _builder    = [NAVUpdateBuilder new];
        _builder.delegate = self;
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

- (id<NAVRouterFactory>)factoryForBuilder:(NAVUpdateBuilder *)builder
{
    return self.factory;
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
    NSArray *updates = [self updatesFromTransitionComponents:components];
    return updates;
}

- (NSArray *)updatesFromTransitionComponents:(NAVURLTransitionComponents *)components
{
    return [self updatesFromTransitionComponents:components withBuilder:self.builder];
}

- (NSArray *)updatesFromTransitionComponents:(NAVURLTransitionComponents *)components withBuilder:(NAVUpdateBuilder *)update
{
    NSMutableArray *updates = [NSMutableArray new];
    for(NAVURLParameter *parameter in components.parametersToDisable)
        [updates addObject:update.with.parameter(parameter).build()];
    
    if(components.componentToReplace)
        [updates addObject:update.with.component(components.componentToReplace).as(NAVUpdateTypeReplace).build()];
    
    if(components.componentsToPop.count)
        [updates addObject:update.with.component(components.componentsToPop.firstObject).as(NAVUpdateTypePop).build()];
    
    for(NAVURLComponent *component in components.componentsToPush)
        [updates addObject:update.with.component(component).as(NAVUpdateTypePop).build()];
    
    for(NAVURLParameter *parameter in components.parametersToEnable)
        [updates addObject:update.with.parameter(parameter).build()];
    
    return updates;
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
