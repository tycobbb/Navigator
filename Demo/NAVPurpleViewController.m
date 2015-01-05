//
//  NAVPurpleViewController.m
//  Navigator
//

#import "NAVPurpleViewController.h"
#import "NAVDemoRouter.h"

@implementation NAVPurpleViewController

- (IBAction)didTapCloseButton:(UIButton *)button
{
    [NAVDemoRouter router].transition
        .parameter(NAVDemoRoutePurple, NAVParameterOptionsHidden)
        .start(nil);
}

@end
