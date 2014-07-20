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
    
    NAVURLTransitionComponents *components =
        [self.parser router:self transitionComponentsFromURL:transaction.sourceURL toURL:transaction.destinationURL];
    NSArray *updates = [self updatesFromTransitionComponents:components];
    
    NAVLog(@"%@", updates);
}

//
// Accessors
//

- (BOOL)isTransitioning
{
    return self.currentTransaction != nil;
}

# pragma mark - Update Generation

- (NSArray *)updatesFromTransitionComponents:(NAVURLTransitionComponents *)components
{
    NSMutableArray *updates = [NSMutableArray new];
    for(NAVURLParameter *parameter in components.parametersToDisable)
        [updates addObject:[self updateForParameter:parameter]];
    
    if(components.componentToReplace)
        [updates addObject:[self updateForComponent:components.componentToReplace]];
    
    for(NAVURLComponent *component in components.componentsToPop)
        [updates addObject:[self updateForComponent:component]];
    
    for(NAVURLComponent *component in components.componentsToPush)
        [updates addObject:[self updateForComponent:component]];
    
    for(NAVURLParameter *parameter in components.parametersToEnable)
        [updates addObject:[self updateForParameter:parameter]];
    
    return updates;
}

- (NAVUpdate *)updateForComponent:(NAVURLComponent *)component
{
    return [NAVUpdate new];
}

- (NAVUpdate *)updateForParameter:(NAVURLParameter *)parameter
{
    return [NAVUpdate new];
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

# pragma mark - Strings

NSString * const NAVRouterDidUpdateURLNotification = @"NAVRouterDidUpdateURLNotification";
NSString * const NAVRouterNotificationURLKey       = @"NAVRouterNotificationURLKey";

NSString * const NAVComponentsToReplaceKey  = @"NAVComponentsToReplaceKey";
NSString * const NAVComponentsToPushKey    = @"NAVComponentsToPushKey";
NSString * const NAVComponentsToPopKey     = @"NAVComponentsToPopKey";
NSString * const NAVParametersToEnableKey  = @"NAVParametersToEnableKey";
NSString * const NAVParametersToDisableKey = @"NAVParametersToDisableKey";
