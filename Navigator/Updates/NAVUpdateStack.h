//
//  NAVUpdateStack.h
//  Navigator
//

@import UIKit;

#import "NAVUpdate.h"

@interface NAVUpdateStack : NAVUpdate

/**
 @brief The view controller assosciated with this update.
 
 This is created at some point before performing the update, and should not be
 relied upon until the update is being performed.
*/

@property (strong, nonatomic) UIViewController<NAVRouteDestination> *controller;

/**
 @brief The URL component assosciated with this update.
 
 The component may be used to gather information about where in the navigation
 stack this update occurs.
*/

@property (nonatomic, readonly) NAVURLComponent *component;

@end
