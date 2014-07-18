//
//  NAVRouter.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRouter.h"
#import "NAVTransaction.h"
#import "NAVUpdate.h"
#import "NSError+NAVRouter.h"

#if NAVRouterLogLevel
    #define NAVLog(_format, ...) NSLog(_format, __VA_LIST__)
#else
    #define NAVLog(_format, ...)
#endif

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
        _scheme = scheme;
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
}

//
// Accessors
//

- (BOOL)isTransitioning
{
    return self.currentTransaction != nil;
}

# pragma mark - Update Generation

- (NSArray *)updatesForTransaction:(NAVTransaction *)transaction
{
    switch(transaction.URLType)
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
