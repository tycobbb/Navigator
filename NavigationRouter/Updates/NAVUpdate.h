//
//  NAVUpdate.h
//  NavigationRouter
//

@import Foundation;

#import "NAVRoute.h"
#import "NAVAttributes.h"

typedef NS_ENUM(NSInteger, NAVUpdateType) {
    NAVUpdateTypePush,
    NAVUpdateTypePop,
    NAVUpdateTypeReplace,
    NAVUpdateTypeAnimation,
};

@interface NAVUpdate : NSObject

/**
 @brief The type of this update
 
 If the update type is .Push, .Pop, or .Replace, then this update is a change to the
 view stack. The destination of the route should be a view controller class.
 
 IF the update type is .Animation, then this update is a change to a view independent
 of the view stack. The destination of this route should be a NAVAnimation.
*/

@property (assign, nonatomic) NAVUpdateType type;

/**
 @brief The route corresponding to this update
 
 The route captures both the key of the URL component/parameter which this update corresponds
 to and the desintation update used to resolve the transition
*/

@property (strong, nonatomic) NAVRoute *route;

/**
 @brief The attributes assosciated with this update
 
 The attributes will be delivered to the route's destination object during the update's
 execution.
*/

@property (strong, nonatomic) NAVAttributes *attributes;

@end
