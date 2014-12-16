//
//  NAVNavigationControllerUpdater.m
//  NavigationRouter
//

@import ObjectiveC;

#import "NAVNavigationControllerUpdater.h"
#import "NAVRouterUtilities.h"

#define NAVNavigationControllerDidSetDelegateNotification @"NAVNavigationControllerDidSetDelegate"

@interface NAVNavigationControllerUpdater () <UINavigationControllerDelegate>
@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) id<UINavigationControllerDelegate> navigationDelegate;
@end

@implementation NAVNavigationControllerUpdater

+ (void)initialize
{
    [self swizzleNavigationControllerSetter];
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    NSParameterAssert(navigationController);
    
    if(self = [super init]) {
        // store our direct properties
        _navigationController = navigationController;
        
        // hijack the navigation controller's delegate
        [self updateNavigationDelegate:navigationController.delegate];
        
        // observe delegate updates for this particular nav controller
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationControllerDidSetDelegate:)
                                                     name:NAVNavigationControllerDidSetDelegateNotification object:navigationController];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - NAVRouterUpdater

- (void)performUpdate:(NAVUpdateStack *)update completion:(void(^)(BOOL))completion
{
    switch(update.type) {
        case NAVUpdateTypePush:
            [self performPush:update completion:completion]; break;
        case NAVUpdateTypePop:
            [self performPop:update completion:completion]; break;
        case NAVUpdateTypeReplace:
            [self performReplace:update completion:completion]; break;
        default:
            NAVAssert(false, NSInternalInconsistencyException, @"Navigation controller can't perform update of type: %d", (int)update.type);
    }
}

- (void)performReplace:(NAVUpdateStack *)update completion:(void(^)(BOOL))completion
{
    self.navigationController.viewControllers = @[ update.controller ];
    nav_call(completion)(YES);
}

- (void)performPop:(NAVUpdateStack *)update completion:(void (^)(BOOL))completion
{
    update.controller = self.navigationController.viewControllers[update.component.index];
    
    [self performUpdate:update withTransaction:^{
        [self.navigationController popToViewController:update.controller animated:update.isAnimated];
    } completion:completion];
}

- (void)performPush:(NAVUpdateStack *)update completion:(void (^)(BOOL))completion
{
    [self performUpdate:update withTransaction:^{
        [self.navigationController pushViewController:update.controller animated:update.isAnimated];
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

# pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.delegate updater:self didUpdateViewControllers:navigationController.viewControllers];
    
    // forward this method explicitly to original the delegate (if it cares)
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

# pragma mark - Notifications

- (void)navigationControllerDidSetDelegate:(NSNotification *)notification
{
    // we want to know if someone new (and besides us) became the nav controller's delegate
    if(notification.object == self || notification.object == self.navigationDelegate) {
        return;
    }
    
    // if so, let's capture it and set ourselves as the delgate again
    [self updateNavigationDelegate:notification.object];
}

- (void)updateNavigationDelegate:(id<UINavigationControllerDelegate>)navigationDelegate
{
    self.navigationDelegate = navigationDelegate;
    self.navigationController.delegate = self;
}

# pragma mark - Swizzling

static IMP original_setDelegate;

+ (void)swizzleNavigationControllerSetter
{
    // get the delegate setter for navigation controller
    Method method = class_getInstanceMethod(UINavigationController.class, @selector(setDelegate:));
    // swizzle and store the original implementation to call from our swizzled setter
    original_setDelegate = method_setImplementation(method, (IMP)nav_setDelegate);
}

void nav_setDelegate(id self, SEL cmd, id<UINavigationControllerDelegate> delegate)
{
    original_setDelegate(self, cmd, delegate);
    // post a notification that this nav controller updated its delegate
    [[NSNotificationCenter defaultCenter] postNotificationName:NAVNavigationControllerDidSetDelegateNotification object:self];
}

@end
