//
//  NAVNavigationControllerUpdater.m
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVRouterNavigationControllerUpdater.h"
#import "NAVUpdate.h"

@interface NAVRouterNavigationControllerUpdater ()
@property (weak, nonatomic) UINavigationController *navigationController;
@end

@implementation NAVRouterNavigationControllerUpdater

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    if(self = [super init])
        _navigationController = navigationController;
    return self;
}

# pragma mark - NAVRouterUpdater

- (void)performReplace:(NAVUpdate *)update withViewController:(UIViewController *)viewController completion:(void(^)(BOOL))completion
{
    self.navigationController.viewControllers = @[ viewController ];
    if(completion)
        completion(YES);
}

- (void)performPop:(NAVUpdate *)update toIndex:(NSInteger)index withCompletion:(void (^)(BOOL))completion
{
    [self performTransaction:^{
        UIViewController *viewController = self.navigationController.viewControllers[index];
        [self.navigationController popToViewController:viewController animated:update.isAnimated];
    } withCompletion:completion];

}

- (void)performPush:(NAVUpdate *)update withViewController:(UIViewController *)viewController withCompletion:(void (^)(BOOL))completion
{
    [self performTransaction:^{
        [self.navigationController pushViewController:viewController animated:update.isAnimated];
    } withCompletion:completion];
}

//
// Helpers
//

- (void)performTransaction:(void(^)(void))transaction withCompletion:(void(^)(BOOL finished))completion
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if(completion)
            completion(YES);
    }];
    
    transaction();
    [CATransaction commit];
}

@end
