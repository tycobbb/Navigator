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
 
 @param url The attributes' source URL
 
 @return A new NAVAttributes instance
*/
- (NAVAttributes *)attributesFromUrl:(NAVURL *)url;

# pragma mark - Chaining

/**
 @brief Registers a transformer to apply to the source URL

 When the attributes are built with the base URL, the transforms are applied in 
 registration-order, and the resultant URL is set as the attribute's destination URL.
 
 @return A block that may be called @c attributes.transform(<transformer>) to add a
 transformer for future application and that returns the builder for chaining.
*/

- (NAVAttributesBuilder *(^)(NAVAttributesUrlTransformer))transform;

/**
 @brief Stores a user object to pass to the resultant attributes
 
 The user object (as well as the attributes) can be captured as the router runs its
 transitions and delivered to the approriate destination.
 
 @return A block that may be called @c attributes.object(<object>) to add an object to
 the built attributes and that returns the builder for chaining.
*/

- (NAVAttributesBuilder *(^)(id))object;

/**
 @brief Stores a handler to pass to the resultant attributes
 
 The handler as well as the attributes) can be captured as the router runs its transitions 
 and delivered to the approriate destination.
 
 @return A block that may be called @c attributes.object(<object>) to add an object to
 the built attributes and that returns the builder for chaining.
*/

- (NAVAttributesBuilder *(^)(id))handler;

@end
