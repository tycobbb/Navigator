//
//  NAVRouter.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRouteBuilder.h"

@implementation NAVRouteBuilder

- (instancetype)init
{
    return [self initWithRoutes:nil];
}

- (instancetype)initWithRoutes:(NSDictionary *)routes
{
    if(self = [super init])
        _routes = [routes mutableCopy] ?: [NSMutableDictionary new];
    return self;
}

- (NAVRoute *(^)(NSString *))to
{
    // create a new route
    NAVRoute *route = [NAVRoute new];
    
    return ^ NAVRoute * (NSString *component) {
        // update the route with the component and register it in the routing map
        route.component = component;
        self.routes[component] = route;
        
        // chain away!
        return route;
    };
}

- (void(^)(NSString *))remove
{
    return ^(NSString *component) {
        [self.routes removeObjectForKey:component];
    };
}

@end

@implementation NAVRoute (Builder)

- (NAVRoute *(^)(NAVRouteType))as
{
    return ^ NAVRoute * (NAVRouteType type) {
        self.type = type;
        return self;
    };
}

@end

