//
//  NAVUpdateStack.h
//  NavigationRouter
//

@import UIKit;

#import "NAVUpdate.h"

@interface NAVUpdateStack : NAVUpdate

/**
 @brief The view controller assosciated with this update.
 
 This is created at some point before performing the update, and should not be
 relied upon until the update is being performed.
*/

@property (strong, nonatomic) UIViewController *controller;

@end
