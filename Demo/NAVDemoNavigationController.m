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
}

@end
