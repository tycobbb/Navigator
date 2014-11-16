//
//  NAVAttributesBuilder.h
//  NavigationRouter
//

@import Foundation;

#import "NAVURL.h"

@class NAVAttributes;

@interface NAVAttributesBuilder : NSObject

/// Transformation block encapsulating a URL mutation
typedef NAVURL *(^NAVAttributesUrlTransformer)(NAVURL *);

/**
 @brief Constructs a attribtues object from the source URL.
 
 The transformations will be applied in order to the source URL to generate the
 destination URL, and any data objects will be stored on the resultant attributes.
 
 @param block:source The attributes' source URL
 
 @return A block that can be called to build a new attributes instance
*/

- (NAVAttributes *(^)(NAVURL *source))build;

/**
 @brief Registers a transformer to apply to the source URL

 When the attributes are built with the base URL, the transforms are applied in 
 registration-order, and the resultant URL is set as the attribute's destination URL.
 
 @param block:url The url to transform
 
 @return A block that can be calleed to add a new URL transformer for future application
*/

- (NAVAttributesBuilder *(^)(NAVAttributesUrlTransformer))transform;

/**
 @brief Stores a user object to pass to the resultant attributes
 
 The user object (as well as the attributes) can be captured as the router runs its
 transitions and delivered to the approriate destination.
 
 @param block:object The user object to assosciate
 
 @return A block that can be called to add an object to the future attributes
*/

- (NAVAttributesBuilder *(^)(id))object;

/**
 @brief Stores a handler to pass to the resultant attributes
 
 The handler as well as the attributes) can be captured as the router runs its transitions 
 and delivered to the approriate destination.
 
 @param block:handler A callback handler to assosciate
 
 @return A block that can be called to add a handler to the future attributes
*/

- (NAVAttributesBuilder *(^)(id))handler;

@end

@interface NAVAttributesBuilder (Convenience)

/**
 @brief Registers a transformer that pushes a subpath onto the source URL
 
 See @c transform for complete documenation on transforms.
*/

- (NAVAttributesBuilder *(^)(NSString *))push;

/**
 @brief Registers a transformer that pops a subpath off the source URL
 
 See @c transform for complete documentation on transforms.
*/

- (NAVAttributesBuilder *(^)(NSInteger))pop;

/**
 @brief Registers a transformer that updates the key-value parameter on the source URL
 
 See @c transform for complete documentation on transforms.
*/

- (NAVAttributesBuilder *(^)(NSString *, NAVParameterOptions))parameter;

@end
