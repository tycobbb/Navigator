//
//  NAVAnimationModal.m
//  Navigator
//

#import "NAVAnimationModal.h"
#import "NAVRouterFactory.h"
#import "NAVRouterUtilities.h"
#import "NAVRouterConstants.h"

@interface NAVAnimationModal ()
@property (copy  , nonatomic) NAVRoute *route;
@property (strong, nonatomic) UIViewController<NAVRouteDestination> *controller;
@property (nonatomic, readonly) UIViewController *presentingViewController;
@end

@implementation NAVAnimationModal

- (instancetype)init
{
    return [self initWithRoute:nil];
}

- (instancetype)initWithRoute:(NAVRoute *)route
{
    NAVAssert(route.type == NAVRouteTypeStack, NAVExceptionInvalidRoute, @"Cannot create a modal animator without a modal route.");
    
    if(self = [super init]) {
        self.route = route;
    }
    
    return self;
}

# pragma mark - Lifecycle

- (void)prepareForAnimationWithFactory:(id<NAVRouterFactory>)factory
{
    [super prepareForAnimationWithFactory:factory];
    
    // only create a view controller if we don't already have one
    if(!self.controller) {
        self.controller = [factory controllerForRoute:self.route];
    }
}

- (void)updateWithAttributes:(NAVAttributes *)attributes
{
    [super updateWithAttributes:attributes];
    
    // pass attributes through to the controller
    [self.controller updateWithAttributes:attributes];
}

- (void)updateIsVisible:(BOOL)isVisible animated:(BOOL)animated completion:(void(^)(BOOL))completion
{
    void(^modalCompletion)(void) = ^{
        nav_call(completion)(YES);
    };
    
    if(isVisible) {
        [self.presentingViewController presentViewController:self.controller animated:animated completion:modalCompletion];
    }
    else {
        [self.controller dismissViewControllerAnimated:animated completion:modalCompletion];
    }
}

- (void)didFinishAnimationToVisible:(BOOL)isVisible
{
    [super didFinishAnimationToVisible:isVisible];
    
    // throw the controller away after we're done animating
    if(!isVisible) {
        self.controller = nil;
    }
}

//
// Helpers
//

- (UIViewController *)presentingViewController
{
    return [self presentedControllerForController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)presentedControllerForController:(UIViewController *)controller
{
    // traverse down the presenting vc tree until we find the leaf
    if(!controller.presentedViewController) {
        return controller;
    }
    
    return [self presentedControllerForController:controller.presentedViewController];
}

# pragma mark - Accessors

- (BOOL)completesAsynchronously
{
    return YES;
}

@end
