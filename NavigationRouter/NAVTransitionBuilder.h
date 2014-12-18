//
//  NAVAttributesBuilder.h
//  NavigationRouter
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

- (void(^)(void(^)(NSError *)))start;

/**
 @brief Enqueues a transition to start at some point in the future

 If there is no currently executing transition, then this transition executes immediately. Otherwise,
 the transition will be queued to run after all presently queued transitions complete.
 
 @note Queued transitions begin from the URL after all previously queued transitions complete.
 
 @param block:completion A callback when this transition completes
*/

- (void(^)(void(^)(void)))enqueue;

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
typedef NAVURL *(^NAVTransitionUrlTransformer)(NAVURL *);

/**
 @brief Registers a transformer to apply to the source URL

 When the attributes are built with the base URL, the transforms are applied in 
 registration-order, and the resultant URL is set as the attribute's destination URL.
 
 @param block:url The url to transform
 
 @return A block that can be calleed to add a new URL transformer for future application
*/

- (NAVTransitionBuilder *(^)(NAVTransitionUrlTransformer))transform;

/**
 @brief Adds a transformer that pushes a subpath onto the source URL
 
 See @c transform for complete documentation on transforms.
*/

- (NAVTransitionBuilder *(^)(NSString *))push;

/**
 @brief Adds a transformer that appends the data string to the last URL component
 
 See @c transform for complete doucmentation on transforms.
*/
- (NAVTransitionBuilder *(^)(NSString *))data;

/**
 @brief Adds a transformer that pops a subpath off the source URL
 
 See @c transform for complete documentation on transforms.
*/

- (NAVTransitionBuilder *(^)(NSInteger))pop;

/**
 @brief Adds a transformer that updates the key-value parameter on the source URL
 
 See @c transform for complete documentation on transforms.
*/

- (NAVTransitionBuilder *(^)(NSString *, NAVParameterOptions))parameter;

@end
