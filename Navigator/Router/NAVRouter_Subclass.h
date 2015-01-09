//
//  NAVRouter_Subclass.h
//  Navigator
//

#import "NAVRouter.h"
#import "NAVRouterConstants.h"
#import "NAVRouterUtilities.h"

@interface NAVRouter (Subclass)

/**
 @brief A string scheme for the router's URLs
 
 All URLs internal to the router will be namespaced to this scheme. The router uses
 this to both generate new URLs and to detect external URLs.

 @return A string scheme to apply to the URLs
*/

+ (NSString *)scheme;

/**
 @brief Provides a hook for subclasses to register their default routes
 
 This method will be called once and only once, and it will be called immediately
 after the router is instantiated.

 @param route A route builder to update the router's default routes
*/

- (void)routes:(NAVRouteBuilder *)route;

/**
 @brief Instantiates the default factory used by this router
 
 The default implementation returns nil, though if the @c View submodule is included 
 it provides an implementation that creates controllers from storyboards.
 
 @return An new object that conforms to @c NAVRouterFactory
*/

- (id<NAVRouterFactory>)defaultFactory;

@end
