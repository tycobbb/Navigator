//
//  NAVAttributesBuilder.h
//  Navigator
//

@import Foundation;

#import "NAVURL.h"

@class NAVAttributes;

@interface NAVTransitionBuilder : NSObject

/**
 @brief Starts the transition immediately.
 
 If the router has a currently running transition, then this transition will @em not 
 run. In this case, the completion will be called immediately with an error.
 
 Alternatively, the transition can be queued using @c -enqueue:.
 
 @param block:completion A callback when the transition completes, or if it couldn't complete.
*/

- (void (^)(void (^)(NSError *)))start;

/**
 @brief Enqueues a transition to start at some point in the future

 If there is no currently executing transition, then this transition executes immediately. Otherwise,
 the transition will be queued to run after all presently queued transitions complete.
 
 @note Queued transitions begin from the URL after all previously queued transitions complete.
 
 @param block:completion A callback when this transition completes
*/

- (void (^)(void (^)(void)))enqueue;

@end

@interface NAVTransitionBuilder (Chaining)

/**
 @brief Stores a user object to pass to the resultant transition's attributes
 
 The user object (as well as the attributes) can be captured as the router runs its
 transitions and delivered to the approriate destination.
 
 @param block:object The user object to assosciate
 
 @return A block that can be called to add an object to the future attributes
*/

- (NAVTransitionBuilder *(^)(id))object;

/**
 @brief Stores a handler to pass to the resultant transition's attributes
 
 The handler, as well as the attributes, can be captured as the router runs its transitions
 and delivered to the approriate destination.
 
 @param block:handler A callback handler to assosciate
 
 @return A block that can be called to add a handler to the future attributes
*/

- (NAVTransitionBuilder *(^)(id))handler;

/**
 @brief Indicates whether the transition should be animated
 
 The default is YES. Transitions need only leverage this builder method to make a transition
 universally unanimated.
 
 @param block:animated Flag indicating whether the transition is animated
 
 @return A block that can be called to set the animated flag
*/

- (NAVTransitionBuilder *(^)(BOOL))animated;

@end

@interface NAVTransitionBuilder (URLs)

/// Transformation block encapsulating a URL mutation
typedef NAVURL *(^NAVTransitionUrlTransform)(NAVURL *);

/**
 @brief @em Transform: pops subpaths off if the path exists in the url, pushes a subpath on if it does not already exist,
 does nothing if the last component on the source url matches the path
 See @c transform for complete documentation on transforms.
 */

- (NAVTransitionBuilder *(^)(NSString *))resolve;

/**
 @brief @em Transform: updates the root of the url, discarding any other URL components
 See @c transform for complete documentation on transforms.
*/

- (NAVTransitionBuilder *(^)(NSString *))root;

/**
 @brief @em Transform: pushes a subpath onto the source URL
 See @c transform for complete documentation on transforms.
*/

- (NAVTransitionBuilder *(^)(NSString *))push;

/**
 @brief @em Transform: pops a subpath off the source URL
 @em transformer: See @c transform for complete documentation on transforms.
*/

- (NAVTransitionBuilder *(^)(NSInteger))pop;

/**
 @brief @em Transform: appends the data string to the last URL component
 See @c transform for complete doucmentation on transforms.
*/
- (NAVTransitionBuilder *(^)(NSString *))data;

/**
 @brief @em Transform: presents the view corresponding to the parameter key
 
 This is a convenience method for presenting a view controller modally. It is a
 pass-through to @c parameter that assumes @c NAVParameterOptionsVisible and
 @c NAVParameterOptionsModal as options.
 
 See @c transform for complete documentation on transforms.
*/

- (NAVTransitionBuilder *(^)(NSString *))present;

/**
 @brief @em Transform: presents the view corresponding to the parameter key
 
 This is a convenience method for presenting a view controller modally. It is a
 pass-through to @c parameter that assumes @c NAVParameterOptionsHidden and
 @c NAVParameterOptionsModal as options.
 
 See @c transform for complete documenation on transforms.
*/

- (NAVTransitionBuilder *(^)(NSString *))dismiss;

/**
 @brief @em Transform: animates the view corresponding to the parameter key
 
 This is a convenience method for running animations, and it's a pass-through to @c parameter
 with the @c NAVParameterOptions corresponding to the @c isVisible flag.
 
 @param block:key       The key for the animation to update
 @param block:isVisible @c YES if the animation should be animated to visible
*/

- (NAVTransitionBuilder *(^)(NSString *, BOOL))animate;

/**
 @brief @em Transform: updates the key-value parameter on the source URL
 See @c transform for complete documentation on transforms.
*/

- (NAVTransitionBuilder *(^)(NSString *, NAVParameterOptions))parameter;


/**
 @brief Registers a transform to apply to the source URL

 Transition are run relative to the router's current URL right before execution. At that time, any
 transforms registered during construction, either through this method or and of the specified
 convenience methods, are then applied in-order to the router's current URL. The resultant URL forms
 the transitions destination URL.
 
 @param block:url The url to transform
 
 @return A block that can be calleed to add a new URL transformer for future application
*/

- (NAVTransitionBuilder *(^)(NAVTransitionUrlTransform))transform;

@end
