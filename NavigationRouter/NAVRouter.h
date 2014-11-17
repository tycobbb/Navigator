//
//  NAVRouter.h
//  NavigationRouter
//

@import Foundation;

#import "NAVRouterDelegate.h"
#import "NAVRouterUpdater.h"
#import "NAVRouterFactory.h"
#import "NAVRouteBuilder.h"

@interface NAVRouter : NSObject

/**
 @brief Sends events concerning the router's update lifecycle. Optional
 
 A user may set the delegate of the router to receive such events, and it also provides a 
 customization point to modify router behavior before it executes.
 
 @return The current delegate instance
*/

@property (weak  , nonatomic) id<NAVRouterDelegate> delegate;

/**
 @brief Provides an interface for the router to run view controller stack updates. Required.
 
 NAVRouterNavigationControllerUpdater provides a default implementation for instances of 
 UINavigationController. If the user sets the router's delegate and that delgate is a navigation 
 controller or has a method named navigationController, as a convenience the router will 
 create in instance of this class from the UINavigationController.
 
 @see @p NAVRouterNavigationControllerUpdater @p
 
 @return The current updater instance.
*/

@property (strong, nonatomic) id<NAVRouterUpdater> updater;

/**
 @brief Creates view controller and animators. Required.
 
 Provides an interface for the router to create these components in order to populate and 
 properly execute routing updates without knowledge of their internals.
 
 @return The current factory instance.
*/

@property (strong, nonatomic) id<NAVRouterFactory> factory;

/**
 @brief Per-class shared instance.
 
 @return A router instance.
*/

+ (instancetype)router;

/**
 @brief Updates the router's internal routes
 
 Routes may be added at runtime using this method, in addition to the default routes subclasses 
 define in @c -routes:. If a new routes matches the subpath of an exisitng route, the existing 
 route will be overwritten.
 
 @param routingBlock A block that executes the route updates
*/

- (void)updateRoutes:(void(^)(NAVRouteBuilder *route))routingBlock;

@end
