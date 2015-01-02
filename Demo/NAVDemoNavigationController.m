//
//  NAVDemoMainViewController.m
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVDemoNavigationController.h"
#import "NAVDemoRouter.h"

@implementation NAVDemoNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    [NAVDemoRouter router].navigationController = self;
    
    [NAVDemoRouter router].transition
        .root(NAVDemoRouteRed)
        .parameter(NAVDemoRoutePurple, NAVParameterOptionsVisible | NAVParameterOptionsAsync)
        .animated(NO)
        .start(nil);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [NAVDemoRouter router].transition
//        .push(NAVDemoRouteBlue)
//        .start(nil);
  
//    [NAVDemoRouter router].transition
//        .push(NAVDemoRouteBlue)
//        .start(nil);

//    [NAVDemoRouter router].transition
//        .dismiss(NAVDemoRoutePurple)
//        .pop(1)
//        .enqueue(nil);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
