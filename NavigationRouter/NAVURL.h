//
//  NAVURL.h
//  NavigationRouter
//

@import Foundation;

#import "NAVURLElement.h"

@interface NAVURL : NSObject

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
 @brief Initializes a NAVURL by parsing a string path.
 
 If the path does not conform to the NAVURL standard, the initializer will throw
 an exception.

 @param path The URL path to parse
 
 @return A NAVURL instance representing this path
*/

- (instancetype)initWithPath:(NSString *)path;

@end
