//
//  NAVURL.h
//  NavigationRouter
//

@import Foundation;

#import "NAVURLElement.h"

@interface NAVURL : NSObject <NSCopying>

/**
 @brief Namespace for URLs
 
 URLs must at a minimum contain a scheme to be considered valid. Any URL constructed 
 without a scheme will through an exception.
*/

@property (copy, nonatomic, readonly) NSString *scheme;

/**
 @brief Array of URL path components
 
 Components are objects of type NAVURLComponent representing views on the navigation 
 stack, and they are listed in sorted order.
*/

@property (copy, nonatomic, readonly) NSArray *components;

/**
 @brief Array of URL query parameters
 
 Parameters are objects of type NAVURLParameter representing animatable, non-stack
 views such as modals, popovers, etc.
*/

@property (copy, nonatomic, readonly) NSArray *parameters;

/**
 @brief Creates a NAVURL by parsing a string path.
 
 If the path is nil, this method returns nil. Otherwise, it will return a new NAVURL
 provided the path is valid.
 
 @param path The URL path to parse
 
 @return A NAVURL instance representing the path, or nil.
*/

+ (instancetype)URLWithPath:(NSString *)path;

/**
 @brief Initializes a NAVURL by parsing a string path.
 
 If the path does not conform to the NAVURL standard, the initializer will throw
 an exception.

 @param path The URL path to parse
 
 @return A NAVURL instance representing this path
*/

- (instancetype)initWithPath:(NSString *)path;

@end

@interface NAVURL (Operators)

/**
 @brief Creates a new URL by appending the component to the existing path.
 
 The rest of the URL (parameters) are preserved as-is. If the component is nil,
 this method will throw an error will throw an error.
 
 @param component The component to append to the path

 @return
*/

- (NAVURL *)push:(NSString *)subpath;

@end
