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

- (NAVRoute *)toPath:(NSString *)path
{
    NAVRoute *route = [NAVRoute new];
    route.path = path;
    
    self.routes[path] = route;
    
    // chain away!
    return route;
}

- (NAVRoute *(^)(NSString *))to
{
    return ^(NSString *path) {
        return [self toPath:path];
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
    return ^(NAVRouteType type) {
        self.type = type;
        return self;
    };
}

- (NAVRoute *(^)(Class))controller
{
    return ^(Class klass) {
        self.destination = klass;
        return self;
    };
}

- (NAVRoute *(^)(NAVAnimation *))animation
{
    return ^(NAVAnimation *animation) {
        self.destination = animation;
        return self;
    };
}

- (NAVRoute *)with
{
    return self;
}

@end

