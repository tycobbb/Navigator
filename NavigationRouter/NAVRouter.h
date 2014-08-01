//
//  NAVRouter.h
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRouterDelegate.h"
#import "NAVRouterParser.h"
#import "NAVRouterUpdater.h"
#import "NAVRouterFactory.h"
#import "NAVRouteBuilder.h"
#import "NAVAttributesBuilder.h"

#define NAVRouterLogLevel 1

@interface NAVRouter : NSObject

/**
 @brief Sends events concerning the router's update lifecycle. Optional
 
 A user may set the delegate of the router to receive such events, and it also provides a customization point
 to modify router behavior before it executes.
 
 @return The current delegate instance
*/

@property (weak  , nonatomic) id<NAVRouterDelegate> delegate;

/**
 @brief Provides an interface for the router to run view controller stack updates. Required.
 
 NAVRouterNavigationControllerUpdater provides a default implementation for instances of UINavigationController.
 If the user sets the router's delegate and that delgate is a navigation controller or has reference to a method 
 named navigationController, as a convenience the router will create in instance of this class from the
 UINavigationController.
 
 @see @p NAVRouterNavigationControllerUpdater @p
 
 @return The current updater instance.
*/

@property (strong, nonatomic) id<NAVRouterUpdater> updater;

/**
 @brief Parses the transition between two URLs into relevant components. Required.
 
 Provides an interface for the router to comparmentalize these components into an instance of NAVRouterTransitionComponents
 when transitioning between two URLs.
 
 NAVURLParser provides a default implementation, and the router will create an instance internally.
 
 @see @p NAVRouterTransitionComponents @p, @p NAVURLParser @p
 
 @return The current parser instance.
*/

@property (strong, nonatomic) id<NAVRouterParser> parser;

/**
 @brief Creates view controller and animators. Required.
 
 Provides an interface for the router to create these components in order to populate and properly execute routing
 updates without knowledge of their internals.
 
 @return The current factory instance.
*/

@property (strong, nonatomic) id<NAVRouterFactory> factory;

/**
 @brief The router's internal URL scheme.
 
 Used by the router to disambiguate between interal and external URLs. Specified in the router's designated initializer,
 initWithScheme:.
 
 @see @p initWithScheme: @p
 
 @return The router's URL scheme.
*/

@property (copy  , nonatomic, readonly) NSString *scheme;

/**
 @brief The URL representing the router's current state.
 
 This URL should correspond to the view state of the slice of application managed by this router (provided proper API
 consumption). The subsequent update will be compared against this URL to determine which updates to run.
 
 @return The URL representing the router's current state.
*/

@property (copy  , nonatomic, readonly) NSURL *currentURL;

/**
 @brief Indicates whether or not the router is running a transition.
 
 By default, the router can only process and execute one transition at a time, and any transitions attempted during 
 an exising transitions execution will be discarded and produce a soft error.
 
 @return Whether or not a transition is currently running.
*/

@property (assign, nonatomic, readonly) BOOL isTransitioning;

/**
 @brief Designated initializer.
 
 Initializes a new router with the given URL scheme, and populates the initial, unspecified URL with that scheme. 
 The scheme must not be nil.

 The router will uses this scheme to determine whether or a URL specified in a transition represents an internal
 state update or a transition to some external source.

 @param scheme The URL scheme for this router

 @return A new router instance with the specified URL scheme.
*/

- (instancetype)initWithScheme:(NSString *)scheme;

/**
 @brief Updates the router's internal routes.
 
 The parameterized block should use the builder to specify how the router's internal routes be updated. Existing
 routes will be overwritten if the path (.to) already exists.
 
 @code [self.router updateRoutes:^(NAVRouteBuilder *route) {
    route.to(@"home").as(NAVRouteTypeStack).with.controllerClass([HomeViewController class]);
 }] @endcode
 
 @param routingBlock A transaction of route updates executed on the parameterized NAVRouteBuilder.
*/

- (void)updateRoutes:(void(^)(NAVRouteBuilder *route))routingBlock;

/**
 @brief Axial method about which all other routing operations orbit. 
 
 Calling this method triggers the router's update cycle, wherein it will diff the destination URL against its current location,
 and perform any necessary interface updates to resolve the transition.
 
 @param attributes Attributes which encapsulate the destination URL as well as any other user information
 @param isAnimated Flag indicating whether or not the transition is animated
 @param completion Block to be called when the transition completes
*/

- (void)transitionWithAttributes:(NAVAttributes *)attributes animated:(BOOL)isAnimated completion:(void(^)(void))completion;

/**
 @brief A builder for constructing new NAVAttributes.
 
 Returns a NAVAttributesBuilder instance configured with the router's current URL. Used as a convenient way
 to generate custom attributes for complex URLs.
 
 @return A NAVAttributesBuilder instance
*/

- (NAVAttributesBuilder *)attributesBuilder;

/**
 @brief Check whether the parameter for a given key is enabled.
 
 Indicates that the corresponding screen/animation/modal is visible.
 
 @param parameter The key for the parameter
 @return Flag indicating whether or not the parameter is enabled.
*/

- (BOOL)parameterIsEnabled:(NSString *)parameter;

@end
