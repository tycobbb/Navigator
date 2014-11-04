//
//  NAVNavigationControllerUpdater.m
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVNavigationControllerUpdater.h"
#import "NAVUpdate.h"

@import ObjectiveC;

@interface NAVNavigationControllerUpdater () <UINavigationControllerDelegate>
@property (weak, nonatomic) id<NAVNavgationControllerUpdaterDelegate> delegate;
@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) id<UINavigationControllerDelegate> navigationDelegate;
@end

@implementation NAVNavigationControllerUpdater

- (instancetype)initWithDelegate:(id<NAVNavgationControllerUpdaterDelegate>)delegate navigationController:(UINavigationController *)navigationController
{
    NSParameterAssert(delegate);
    NSParameterAssert(navigationController);
    
    if(self = [super init]) {
        // store our direct properties
        _delegate = delegate;
        _navigationController = navigationController;
        
        // hijack the navigation controller's delegate
        _navigationDelegate = navigationController.delegate;
        _navigationController.delegate = self;
        
        // observe the navigation controller's delegate so that we can proxy its methods
        // NOTE: this seems dangerous since we don't hold onto the navigation controller, and it could be deallocated
        // while we're observing it
        [navigationController addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}

# pragma mark - Delegate Proxying

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    id delegate = change[NSKeyValueChangeNewKey];
    self.navigationDelegate = delegate;
}

//
// UINavigationControllerDelegate
//

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.delegate updater:self navigationControllerDidUpdateViewControllers:navigationController];
    
    // forward this method onto the delegate if it cares
    if([self.navigationDelegate respondsToSelector:_cmd]) {
        [self.navigationDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

//
// Proxying
//

- (BOOL)respondsToSelector:(SEL)selector
{
    return [super respondsToSelector:selector] || [self shouldForwardSelector:selector];
}

- (id)forwardingTargetForSelector:(SEL)selector
{
    return [self shouldForwardSelector:selector] ? self.navigationDelegate : nil;
}

- (BOOL)shouldForwardSelector:(SEL)selector
{
    // get the corresponding method description from the UINavigationControllerDelegate protocol
    struct objc_method_description method = protocol_getMethodDescription(@protocol(UINavigationControllerDelegate), selector, NO, YES);
    // verify that the method is part of this protocol, and that the original delegate responds to it
    return method.name != NULL && [self.navigationDelegate respondsToSelector:selector];
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
