//
//  NAVNavigationControllerUpdater.h
//  Navigator
//

#import "NAVRouterUpdater.h"

@protocol NAVNavigationControllerUpdaterDelegate;

@interface NAVNavigationControllerUpdater : NSObject <NAVRouterUpdater>

/// Receives relevant navigation controller events as they occur
@property (weak, nonatomic) id<NAVNavigationControllerUpdaterDelegate> delegate;

/**
 @brief Initializes a new updater for this navigation controller
 
 The updater will push/pop/replace view controller's on the navigation controllers stack as
 URL changes (and corresponding updates) occur.
 
 @param navigationController The navigation controller to receive updates

 @return A new NAVNavigationControllerUpdater instance
*/

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end

@protocol NAVNavigationControllerUpdaterDelegate <NSObject>

/**
 @brief Called by the updater whenever the navigation controller finishes showing a view controller
 
 The delegate can use this message to determine if updates are happening outside the router, and
 attempt to recover accordingly.

 @param updater         The updater that received this event
 @param viewControllers The navigation controller's current view controllers
*/

- (void)updater:(NAVNavigationControllerUpdater *)updater didUpdateViewControllers:(NSArray *)viewControllers;

@end
