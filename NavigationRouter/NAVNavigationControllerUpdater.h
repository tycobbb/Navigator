//
//  NAVNavigationControllerUpdater.h
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVRouterUpdater.h"

@protocol NAVNavgationControllerUpdaterDelegate;

@interface NAVNavigationControllerUpdater : NSObject <NAVRouterUpdater>
- (instancetype)initWithDelegate:(id<NAVNavgationControllerUpdaterDelegate>)delegate navigationController:(UINavigationController *)navigationController;
@end

@protocol NAVNavgationControllerUpdaterDelegate <NSObject>
- (void)updater:(NAVNavigationControllerUpdater *)updater navigationControllerDidUpdateViewControllers:(UINavigationController *)navigationController;
@end
