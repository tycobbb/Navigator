//
//  NAVAnimationCachingFactory.h
//  Navigator
//
//  Created by Ty Cobb on 3/12/15.
//
//

#import "NAVRouterFactory.h"

/**
 Caches visible animations so that they can be re-used during dismissal
 
 Actual construction logic is driven by the the @c targetFactory, and that property is
 required for this class to function properly.
*/

@interface NAVAnimationCachingFactory : NSObject <NAVRouterFactory>

/** The @c NAVRouterFactory to delegate actual construction to */
@property (strong, nonatomic) id<NAVRouterFactory> targetFactory;

/** 
 @brief Caches the animation for the specified route
 
 The animation is cached for the route, and then destroyed once its accessed via
 normal factory construction.
 
 @todo This fails if the animations for this route are presented multiple times before any dismissals, since the cache is destroyed on the first dismissal
*/

- (void)cacheAnimation:(NAVAnimation *)animation forRoute:(NAVRoute *)route;

@end
