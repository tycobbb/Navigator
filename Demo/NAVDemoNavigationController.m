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
    
    [NAVDemoRouter router].navigationController = self;
    
    [NAVDemoRouter router].transition
        .push(NAVDemoRouteRed)
        .start(nil);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
    [NAVDemoRouter router].transition
        .push(NAVDemoRouteBlue)
        .parameter(NAVDemoRoutePurple, NAVParameterOptionsVisible)
        .start(nil);
    
    [NAVDemoRouter router].transition
        .parameter(NAVDemoRoutePurple, NAVParameterOptionsHidden)
        .enqueue(nil);
}

@end
