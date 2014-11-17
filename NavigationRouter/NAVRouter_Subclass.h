//
//  NAVRouter_Subclass.h
//  NavigationRouter
//

#import "NAVRouter.h"
#import "NAVRouteBuilder.h"

@interface NAVRouter (Subclass)

/**
 @brief Provides a hook for subclasses to register their default routes
 
 This method will be called once and only once, and it will be called immediately
 after the router is instantiated.

 @param route A route builder to update the router's default routes
*/

- (void)routes:(NAVRouteBuilder *)route;

@end
