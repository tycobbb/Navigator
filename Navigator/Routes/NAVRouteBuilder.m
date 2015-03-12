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
    if(self = [super init]) {
        _routes = [routes mutableCopy] ?: [NSMutableDictionary new];
        _addedRoutes = [NSMutableArray new];
        _removedRoutes = [NSMutableArray new];
    }
    
    return self;
}

- (NAVRoute *)toPath:(NSString *)path
{
    NAVRoute *route = [NAVRoute new];
    route.path = path;
    
    // otherwise, this is a changed route
    // TODO: changed routes, and routes that get added multiple times (:S) aren't going to work
    if(!self.routes[path]) {
        [self.addedRoutes addObject:route];
    }
    
    self.routes[path] = route;
    
    // chain away!
    return route;
}

- (void)removeRouteForComponent:(NSString *)component
{
    NAVRoute *route = self.routes[component];
    
    if(route) {
        [self.removedRoutes addObject:route];
    }
    
    [self.routes removeObjectForKey:component];
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
        [self removeRouteForComponent:component];
    };
}

@end

@implementation NAVRoute (Builder)

- (NAVRoute *(^)(Class))controller
{
    return ^(Class klass) {
        self.destination = klass;
        self.type = NAVRouteTypeStack;
        return self;
    };
}

- (NAVRoute *(^)(NAVAnimation *))animation
{
    return ^(NAVAnimation *animation) {
        self.destination = animation;
        self.type = NAVRouteTypeAnimation;
        return self;
    };
}

- (NAVRoute *)with
{
    return self;
}

@end

