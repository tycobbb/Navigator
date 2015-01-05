//
//  NAVViewController.h
//  Navigator
//

@import UIKit;

#import "NAVRouteDestination.h"

@protocol NAVViewController <NAVRouteDestination>

/**
 @brief Factory method to construct view controller instances
 
 The default implementation attempts to load the view controller from the
 storyboard specified by @c +storyboardName with the identifier matching the name
 of this view controller's class.
 
 Subclasses may override this method to perform custom instantiation.
 
 @return A new view controller instance
*/

+ (instancetype)instance;

/**
 @brief Specifies the storyboard identifier for this view controller.
 
 The default implementation returns a stringified version of the class name. Subclasses 
 may override this method to specify a custom identifier.
 
 @return The storyboard identifier for this view controller.
*/

+ (NSString *)storyboardIdentifier;

/**
 @brief Specifies the name of the storyboard assoscaited with this view controller
 
 The default implemenation throws an exception. Subclasses should implement this method
 so that view contorller's can be constructed successfully.
 
 @return The name of the assosciated storyboard
*/

+ (NSString *)storyboardName;

@end

@interface NAVViewController : UIViewController <NAVViewController>

@end

extern NSString * const NAVExceptionViewConfiguration;
