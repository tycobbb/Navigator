//
//  NAVUpdate.h
//  NavigationRouter
//

@import Foundation;

#import "NAVAttributes.h"

typedef NS_ENUM(NSInteger, NAVUpdateType) {
    NAVUpdateTypeUnknown,
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
 @brief The URL element assosciated to this update

 The URL element is used to determine the route assosciated with this update when
 it needs to be performed.
*/

@property (strong, nonatomic) NAVURLElement *element;


/**
 @brief The attributes assosciated to this update
 
 The attributes will be delivered to the route's destination object during the update's
 execution.
*/

@property (strong, nonatomic) NAVAttributes *attributes;

@end
