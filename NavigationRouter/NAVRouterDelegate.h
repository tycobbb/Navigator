//
//  NAVRouterDelegate.h
//  Created by Ty Cobb on 7/14/14.
//

@import Foundation;

@class NAVRouter;

#import "NAVUpdate.h"

@protocol NAVRouterDelegate <NSObject> @optional

/**
 @brief Notifies the delegate when a sequence of updates is about to be run
 
 The order and type of updates may be depended on at this point, but the indivudal updates
 may not have be fully configured and should not be relied upon.
 
 @param router  The router about to perfrom these updates
 @param updates An array of NAVUpdates about to be performed
*/

- (void)router:(NAVRouter *)router willPerformUpdates:(NSArray *)updates;

/**
 @brief Notifies the delegate when an update is about to run
 
 The update should be fully configured at this point, and the delegate can inspect it
 freely. This method may be called multiple times (with different updates) within an
 individual router transition.
 
 @param router The router about to perform this update
 @param update The update about to be performed
*/

- (void)router:(NAVRouter *)router willPerformUpdate:(NAVUpdate *)update;

/**
 @brief Notifies the delegate that the router finished perform an update
 
 This method may be called multiple times (with different updates) within an individual
 router transition.
 
 @param router The router that just performed this update
 @param update The update that was just performed
*/

- (void)router:(NAVRouter *)router didPerformUpdate:(NAVUpdate *)update;

/**
 @brief Notifies the delegate after all the updates in a transition complete
 
 @param router  The router that performed these updates
 @param updates The updates that were just performed
*/

- (void)router:(NAVRouter *)router didPerformUpdates:(NSArray *)updates;

@end
