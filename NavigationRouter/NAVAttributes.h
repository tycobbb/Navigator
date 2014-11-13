//
//  NAVAttributes.h
//  NavigationRouter
//

#import "NAVURL.h"

@import Foundation;

@class NAVAttributesBuilder;

@interface NAVAttributes : NSObject

/**
 @brief The URL these attributes transition from
*/
@property (copy, nonatomic) NAVURL *source;

/**
 @brief The URL these attributes transition to
*/

@property (copy, nonatomic) NAVURL *destination;

/**
 @brief A user object to deliver along with the transition (optional)
*/

@property (strong, nonatomic) id userObject;

/**
 @brief A callback to deliver along with the transition (optional)
*/

@property (copy, nonatomic) id handler;

/**
 @brief The data string assosciated with the URL component (optional)
*/

@property (copy, nonatomic) NSString *data;

@end

@interface NAVAttributes (Builder)

/**
 @brief Generates a new attributes builder.
 
 The attributes builder encapsulates the logic necessary to construct an attributes object
 when the transition is ready to execute.

 @return A NAVAttributes builder instance
*/

+ (NAVAttributesBuilder *)build;

@end
