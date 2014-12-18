//
//  NAVAttributes.h
//  NavigationRouter
//

@import Foundation;

#import "NAVURL.h"

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
