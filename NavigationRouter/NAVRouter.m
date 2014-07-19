//
//  NAVRouter.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRouter_Private.h"

@interface NAVRouter ()
@property (copy  , nonatomic) NSString *scheme;
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
        _scheme = scheme;
        _parser = [NAVURLParser new];
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
    
    NSDictionary *components = [self.parser router:self componentsForTransitionFromURL:transaction.sourceURL toURL:transaction.destinationURL];
    
    NAVLog(@"%@", components);
}

//
// Accessors
//

- (BOOL)isTransitioning
{
    return self.currentTransaction != nil;
}

# pragma mark - Parsing

- (void)components:(NSMutableDictionary *)components parseParametersFromURL:(NSURL *)sourceURL toURL:(NSURL *)destinationURL
{
//    NSDictionary *sourceParameters      = [sourceURL nav_parameters];
//    NSDictionary *destinationParameters = [destinationURL nav_parameters];
//    
//    NSMutableArray *parametersToEnable  = [NSMutableArray new];
//    NSMutableArray *parametersToDisable = [NSMutableArray new];
//    
//    NSSet *keySet = [self mergeKeysFromDictionary:sourceParameters andDictionary:destinationParameters];
//    for(NSString *key in keySet)
//    {
//        NAVURLParameter *sourceParamater      = sourceParameters[key];
//        NAVURLParameter *destinationParamater = destinationParameters[key];
//        
//        if(!sourceParamater.isVisible && destinationParamater.isVisible)
//            [parametersToEnable addObject:destinationParamater];
//        else if(sourceParamater.isVisible && !destinationParamater.isVisible)
//            [parametersToDisable addObject:destinationParamater ?: sourceParamater];
//    }
//    
//    components[NAVURLKeyParametersToEnable]  = parametersToEnable;
//    components[NAVURLKeyParametersToDisable] = parametersToDisable;
}

- (NSSet *)mergeKeysFromDictionary:(NSDictionary *)dictionary andDictionary:(NSDictionary *)otherDictionary
{
    NSMutableSet *keySet = [[NSMutableSet alloc] initWithArray:dictionary.allKeys];
    [keySet addObjectsFromArray:otherDictionary.allKeys];
    return [keySet copy];
}

# pragma mark - Update Generation

- (NSArray *)updatesForTransaction:(NAVTransaction *)transaction
{
    switch(transaction.destinationURL.type)
    {
        case NAVURLTypeInternal:
            return [self updatesForInternalTransaction:transaction];
        case NAVURLTypeExternal:
            return [self updatesForExternalTransaction:transaction];
    }
}

- (NSArray *)updatesForExternalTransaction:(NAVTransaction *)transaction
{
//    NSString *externalScheme = transaction.destinationURL.scheme;
//    NAVRoute *externalRoute  = [self routeForKey:externalScheme];
    
    return @[ ];
}

- (NSArray *)updatesForInternalTransaction:(NAVTransaction *)transaction
{
    
    return nil;
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

- (NAVRoute *)routeForKey:(NSString *)key
{
    return self.routes[key];
}

@end

# pragma mark - Strings

NSString * const NAVRouterDidUpdateURLNotification = @"NAVRouterDidUpdateURLNotification";
NSString * const NAVRouterNotificationURLKey       = @"NAVRouterNotificationURLKey";

NSString * const NAVURLKeyComponentToReplace  = @"NAVURLKeyComponentToReplace";
NSString * const NAVURLKeyComponentsToPush    = @"NAVURLKeyComponentsToPush";
NSString * const NAVURLKeyComponentsToPop     = @"NAVURLKeyComponentsToPop";
NSString * const NAVURLKeyParametersToEnable  = @"NAVURLKeyParametersToEnable";
NSString * const NAVURLKeyParametersToDisable = @"NAVURLKeyParametersToDisable";
