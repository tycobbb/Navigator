//
//  NAVNavigationControllerUpdater.m
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVRouterNavigationControllerUpdater.h"
#import "NAVUpdate.h"

@interface NAVRouterNavigationControllerUpdater () <UINavigationControllerDelegate>
@property (weak, nonatomic) UINavigationController *navigationController;
@end

@implementation NAVRouterNavigationControllerUpdater

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    if(self = [super init])
    {
        _navigationController = navigationController;
        _navigationController.delegate = self;
    }
    
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
    [self performUpdate:update withTransaction:^{
        UIViewController *viewController = self.navigationController.viewControllers[index];
        [self.navigationController popToViewController:viewController animated:update.isAnimated];
    } completion:completion];

}

- (void)performPush:(NAVUpdate *)update withViewController:(UIViewController *)viewController withCompletion:(void (^)(BOOL))completion
{
    [self performUpdate:update withTransaction:^{
        [self.navigationController pushViewController:viewController animated:update.isAnimated];
    } completion:completion];
}

//
// Helpers
//

- (void)performUpdate:(NAVUpdate *)update withTransaction:(void(^)(void))transaction completion:(void(^)(BOOL finished))completion
{
    void(^transactionCompletion)(void) = ^{
        if(completion)
            completion(YES);
    };
    
    BOOL performCompletionAsynchronously = update.isAnimated;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self dispatchBlock:transactionCompletion asynchronously:performCompletionAsynchronously];
    }];
    
    transaction();
    
    [CATransaction commit];
}

- (void)dispatchBlock:(void(^)(void))block asynchronously:(BOOL)asynchronously
{
    if(!asynchronously && block)
        block();
    else if(block)
        dispatch_async(dispatch_get_main_queue(), block);
}

@end
