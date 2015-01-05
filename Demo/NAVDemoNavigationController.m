//
//  NAVDemoMainViewController.m
//  NavigationRouter
//

#import "NAVDemoNavigationController.h"
#import "NAVDemoRouter.h"
#import "NAVDemoAnimation.h"

@interface NAVDemoNavigationController ()
@property (assign, nonatomic) BOOL didAppear;
@property (strong, nonatomic) NAVAnimation *demoAnimation;
@end

@implementation NAVDemoNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // hook up the router to the navigation controller so that it can update the view
    [NAVDemoRouter router].navigationController = self;

    // configure a custom animation
    self.demoAnimation = [self setupDemoAnimation];
    
    // give the router its initial route, it'll run this as soon as it's ready
    [NAVDemoRouter router].transition
        .root(NAVDemoRouteRed)
        .push(NAVDemoRouteBlue)
        .animated(NO)
        .start(nil);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    // show a modal afer we first appear, and then dismiss it and pop off our second vc
    if(!self.didAppear) {
        [NAVDemoRouter router].transition
            .present(NAVDemoRoutePurple)
            .animated(NO)
            .enqueue(nil);
        
        [NAVDemoRouter router].transition
            .dismiss(NAVDemoRoutePurple)
            .pop(1)
            .present(NAVDemoRouteMenu)
            .enqueue(nil);
    }
    
    self.didAppear = YES;
}

# pragma mark - Animation

- (NAVAnimation *)setupDemoAnimation
{
    // let's create an animation that simulates a drawer menu
    NAVDemoAnimation *animation = [NAVDemoAnimation new];
    animation.animatingView = self.view.subviews.firstObject;
    
    // add a route for this animation
    [[NAVDemoRouter router] updateRoutes:^(NAVRouteBuilder *route) {
        route.to(NAVDemoRouteMenu).animation(animation);
    }];
    
    // add a close button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.backgroundColor = [UIColor orangeColor];
    closeButton.frame = (CGRect){ 0.0f, 100.0f, 50.0f, 50.0f };
    
    [closeButton addTarget:self action:@selector(didTapCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:closeButton atIndex:0];
    
    return animation;
}

- (void)didTapCloseButton:(UIButton *)button
{
    [self.demoAnimation setIsVisible:NO animated:YES completion:nil];
}

@end
