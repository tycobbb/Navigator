//
//  NAVRouter.h
//  Navigator
//

@import Foundation;

#import "NAVRouterDelegate.h"
#import "NAVRouterUpdater.h"
#import "NAVRouterFactory.h"
#import "NAVRouteBuilder.h"
#import "NAVTransitionBuilder.h"

@interface NAVRouter : NSObject

/**
 @brief Sends events concerning the router's update lifecycle. Optional
 
 A user may set the delegate of the router to receive such events, and it also provides a 
 customization point to modify router behavior before it executes.
 
 @return The current delegate instance
*/

@property (weak, nonatomic) id<NAVRouterDelegate> delegate;

/**
 @brief Provides an interface for the router to run view stack updates. Required.
 
 The router internally provides a default updater implementation for @c UINavigationController, 
 which can be created explicitly by setting the router's @c navigationController.
 
 @note If the user sets a router's @c delegate to an object that is a navigation
 controller or has a method named @c navigationController, as a convenience the router will
 create an updater from that navigation controller as well.
 
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
 @brief Indiicates whether a transiiton is currently running
 
 If true, attempted transitions will fail by default. This behavior may be overridden by
 passing the set @c shouldQueue to true on the NAVAttributes passed to
 @c -transitionWithAttributes:animated:completion:.
*/

@property (nonatomic, readonly) BOOL isTransitioning;

/**
 @brief The URL representing the router's current state.
 
 This URL should correspond to the view state of the slice of application managed by this router (provided proper API
 consumption). The subsequent update will be compared against this URL to determine which updates to run.
 
 @return The URL representing the router's current state.
*/

@property (nonatomic, readonly) NAVURL *currentUrl;

/**
 @brief Per-class shared instance.
 
 @return A router instance.
*/

+ (instancetype)router;

/**
 @brief Returns a new transition builder that can be used to run a routing transition
 
 The builder contains a variety of chainable methods for customizing the routing desintation,
 transition attributes, and data passed to routed views.
 
 @see @c NAVTransitionBuilder for a complete list of what's available.
 
 @return A new NAVTransitionBuilder to construct the transition
*/

- (NAVTransitionBuilder *)transition;

/**
 @brief Updates the router's internal routes
 
 Routes may be added at runtime using this method, in addition to the default routes 
 subclasses define in @c -routes:. If a new routes matches the subpath of an exisitng 
 route, the existing route will be overwritten.
 
 @param routingBlock A block that executes the route updates
*/

- (void)updateRoutes:(void(^)(NAVRouteBuilder *route))routingBlock;

/**
 @brief Configures the router to use the navigation controller
 
 The router will use this navigation controller as its updater. This must be called (if that
 behavior is desired) before running the first route.
 
 @param navigationController A navigation controller to use for updates
*/

- (void)setNavigationController:(UINavigationController *)navigationController;

@end
