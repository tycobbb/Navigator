//
//  NAVViewController.h
//  NavigationRouter
//

@import UIKit;

#import "NAVAttributes.h"

@protocol NAVViewController <NSObject>

/**
 @brief Factory method to construct view controller instances
 
 The default implementation attempts to load the view controller from the
 storyboard specified by @c +storyboardName with the identifier matching the name
 of this view controller's class.
 
 Subclasses may override this method to perform custom instantiation.
 
 @return A new view controller instance
*/

+ (instancetype)instance;

@end

@interface NAVViewController : UIViewController <NAVViewController>

/**
 @brief Updates the view controller with the executing transition's attributes
 
 Attributes contain the transitioninging URLs as well as any user object the initiator 
 of the transition may want to pass to the view controller.
 
 Subclasses should override this method to capture information passed to them by other views.
 
 @param attribtues The attributes sent along by the transition initiator.
*/

- (void)updateWithAttributes:(NAVAttributes *)attributes;

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

extern NSString * const NAVExceptionViewConfiguration;
