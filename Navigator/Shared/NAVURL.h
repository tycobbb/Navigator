//
//  NAVURL.h
//  Navigator
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
 @brief Dictionary of URL query parameters
 
 Parameters are objects of type NAVURLParameter representing animatable, non-stack
 views such as modals, popovers, etc. The dictionary is keyed by the parameter name.
*/

@property (copy, nonatomic, readonly) NSDictionary *parameters;

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

@interface NAVURL (Accessors)

/**
 @brief Returns the last NAVURLComponent on this URL
 
 If this URL has no components, then the method returns nil.

 @return The last component, or nil.
*/

- (NAVURLComponent *)lastComponent;

/**
 @brief Returns the NAVURLComponent for the specified index.
 
 If no component exists at the specified index, this method returns nil.
 
 @param index The index of the component
 @return The NAVURLComponent at the index, or nil
*/

- (NAVURLComponent *)objectAtIndexedSubscript:(NSInteger)index;

/**
 @brief Returns the NAVURLParameter for the specified key.

 If no parameter exists for the specified key, this method returns nil.
 
 @param key The key for hte parameter
 @return The NAVURLParameter corresponding to this key, or nil
*/

- (NAVURLParameter *)objectForKeyedSubscript:(NSString *)key;

@end

@interface NAVURL (Operators)

/**
 @brief Creates a new URL by appending the component to the existing path.
 
 The rest of the URL (parameters) are unchanged. If the component is nil, this method 
 throws an exception.
 
 @param component The component to append to the path

 @return A new NAVURL with the component appended
*/

- (NAVURL *)push:(NSString *)subpath;

/**
 @brief Creates a new URL by popping the last component from the path
 
 The rest of the URL (parameters) are unchanged. If there are not enough components 
 to pop, then this method throws an exception.
 
 @param count The number of components to pop
 
 @return A new NAVURL with the last count components removed
*/

- (NAVURL *)pop:(NSUInteger)count;

/**
 @brief Sets the data string for the last URL component
 
 If the URL component has existing data it will be overwritten. If there is no last 
 component, this method does nothing. If the data parameter is nil, the component will
 have its data removed.
 
 @param data The data string to add to the component
 
 @return A new NAVURL with the data added to the last component
*/

- (NAVURL *)setData:(NSString *)data;

/**
 @brief Create a new URL by updating the parameter with the given value.
 
 The rest of the URL (components, other parameters) are unchanged. A parameter will be
 created if it doesn't already exist. If the key is nil, this method throws an exception.
 
 @param key     The key of the parameter to update
 @param options The updated options for the parameter
 
 @return A new NAVURL with the parameter updated
*/

- (NAVURL *)updateParameter:(NSString *)key withOptions:(NAVParameterOptions)options;

@end

@interface NAVURL (Serialization)

/**
 @brief Serializes the URL into a string representation
 
 This operation generates a new string from the URL and sanitizes it of any
 hidden parameters.
*/

@property (nonatomic, readonly) NSString *string;

/**
 @brief Serializes the URL into an NSURL representation
 
 This operation generates a new NSURL from the URL and sanitizes it of any
 hidden parameters.
*/

@property (nonatomic, readonly) NSURL *url;

@end
