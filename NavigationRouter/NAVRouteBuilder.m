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

- (void)removeMatchingPath:(NSString *)path
{
    [self.routes removeObjectForKey:path];
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

- (NAVRoute *)asType:(NAVRouteType)type
{
    self.type = type;
    return self;
}

- (NAVRoute *)withControllerClass:(Class)klass
{
    self.destination = klass;
    return self;
}

- (NAVRoute *)withAnimator:(NAVAnimator *)animator
{
    self.destination = animator;
    return self;
}

- (NAVRoute *(^)(NAVRouteType))as
{
    return ^(NAVRouteType type) {
        return [self asType:type];
    };
}

- (NAVRoute *(^)(Class))controller
{
    return ^(Class klass) {
        return [self withControllerClass:klass];
    };
}

- (NAVRoute *(^)(NAVAnimator *))animator
{
    return ^(NAVAnimator *animator) {
        return [self withAnimator:animator];
    };
}

- (NAVRoute *)with
{
    return self;
}

@end

