//
//  NAVDemoMainViewController.m
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVDemoNavigationController.h"
#import "NAVDemoRouter.h"

@interface NAVDemoNavigationController ()
@property (assign, nonatomic) BOOL didAppear;
@end

@implementation NAVDemoNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    [NAVDemoRouter router].navigationController = self;
    
    [NAVDemoRouter router].transition
        .root(NAVDemoRouteRed)
        .push(NAVDemoRouteBlue)
        .animated(NO)
        .start(nil);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!self.didAppear) {
        [NAVDemoRouter router].transition
            .present(NAVDemoRoutePurple).animated(NO)
            .enqueue(nil);
        
        [NAVDemoRouter router].transition
            .dismiss(NAVDemoRoutePurple)
            .pop(1)
            .enqueue(nil);    
    }
    
    self.didAppear = YES;
}

@end
