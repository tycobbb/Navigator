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
 @brief Initializes a new update of the specified type

 All parameters are required. Failure to pass a valid value for one of the parameters
 results in an exception.
 
 @param type       The type of update
 @param element    The URL element assosciated with this update
 @param attributes The attribtues corresponding to this update
 
 @return A new update instance
*/

- (instancetype)initWithType:(NAVUpdateType)type element:(NAVURLElement *)element attributes:(NAVAttributes *)attributes;

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
