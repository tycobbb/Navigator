//
//  NAVRouterUpdater.h
//  Created by Ty Cobb on 7/14/14.
//

@import UIKit;

@class NAVRouter, NAVUpdate;

@protocol NAVRouterUpdater <NSObject>
- (void)performReplace:(NAVUpdate *)update withViewController:(UIViewController *)viewController completion:(void(^)(BOOL finished))completion;
- (void)performPush:(NAVUpdate *)update withViewController:(UIViewController *)viewController withCompletion:(void(^)(BOOL finished))completion;
- (void)performPop:(NAVUpdate *)update toIndex:(NSInteger)index withCompletion:(void(^)(BOOL finished))completion;
@end
