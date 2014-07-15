//
//  NAVRouter.m
//  Created by Ty Cobb on 3/25/14.
//

#import "NAVRouter.h"
#import "NAVRouteTransformer.h"
#import "NAVRouterConstants.h"

@interface NAVRouter ()
@property (strong, nonatomic) NSDictionary *routes;
@end

@implementation NAVRouter

- (void)updateRoutes:(void(^)(NAVRouteBuilder *route))routingBlock
{
    if(!routingBlock)
        return;
    
    NAVRouteBuilder *routeBuilder = [[NAVRouteBuilder alloc] initWithRoutes:self.routes];
    routingBlock(routeBuilder);

    [self setRoutes:[routeBuilder.routes copy]];
    [NAVRouteTransformer updateRoutes:self.routes];
}

@end

# pragma mark - Strings

NSString * const NAVRouterDidUpdateURLNotification = @"NAVRouterDidUpdateURLNotification";
NSString * const NAVRouterNotificationURLKey       = @"NAVRouterNotificationURLKey";
