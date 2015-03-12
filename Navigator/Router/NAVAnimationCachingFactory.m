//
//  NAVAnimationCachingFactory.m
//  Navigator
//
//  Created by Ty Cobb on 3/12/15.
//

#import "NAVAnimationCachingFactory.h"
#import "NAVRouterUtilities.h"

@interface NAVAnimationCachingFactory ()
@property (strong, nonatomic) NSMutableDictionary *animationCache;
@end

@implementation NAVAnimationCachingFactory

- (instancetype)init
{
    if(self = [super init]) {
        _animationCache = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)cacheAnimation:(NAVAnimation *)animation forRoute:(NAVRoute *)route
{
    NSParameterAssert(animation);
    NSParameterAssert(route);
   
    // cache the animation by the route path
    self.animationCache[route.path] = animation;
}

# pragma mark - NAVRouterFactory

- (UIViewController<NAVRouteDestination> *)controllerForRoute:(NAVRoute *)route
{
    return [self.targetFactory controllerForRoute:route];
}

- (NAVAnimation *)animationForRoute:(NAVRoute *)route
{
    // see if we have a cached aniamtion
    NAVAnimation *animation = self.animationCache[route.path];
  
    // cache is one-time use, so if we find an animation lets use it and remove it
    if(animation) {
        [self.animationCache removeObjectForKey:route.path];
        return animation;
    }
   
    // otherwise, let the factory do its thing
    return [self.targetFactory animationForRoute:route];
}

@end
