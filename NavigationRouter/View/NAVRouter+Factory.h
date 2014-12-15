//
//  NAVRouter+Factory.h
//  NavigationRouter
//

#import "NAVRouter.h"

@interface NAVRouter (Factory)

/**
 @brief Constructs a default factory for the router

 The factory is created during initializating, and may be overridden at any point
 afterwards.
 
 @return A new router factory.
*/

- (id<NAVRouterFactory>)defaultFactory;

@end
