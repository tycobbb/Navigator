//
//  NAVDemoMainViewController.m
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVDemoNavigationController.h"
#import "NAVRouterStoryboardFactory.h"

@interface NAVDemoNavigationController () <NAVRouterDelegate>

@end

@implementation NAVDemoNavigationController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.router = [[NAVRouter alloc] initWithScheme:@"test"];
    self.router.delegate = self;
    self.router.factory  = [NAVRouterStoryboardFactory new];
    
    [self.router updateRoutes:^(NAVRouteBuilder *route) {
        route.to(@"red").as(NAVRouteTypeStack);
        route.to(@"green").as(NAVRouteTypeStack);
        route.to(@"blue").as(NAVRouteTypeStack);
        route.to(@"purple").as(NAVRouteTypeModal);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NAVAttributes_legacy *attributes = [self.router.attributesBuilder toPath:@"/red/blue"].build;
    [self.router transitionWithAttributes:attributes animated:NO completion:^{
        
        NAVAttributes_legacy *attributes = [self.router.attributesBuilder toPath:@"green"].build;
        [self.router transitionWithAttributes:attributes animated:NO completion:^{
            
            NAVAttributes_legacy *attributes = [self.router.attributesBuilder withParameter:@"purple" options:NAVParameterOptions_legacyVisible].build;
            [self.router transitionWithAttributes:attributes animated:YES completion:^{
                [self.router dismissScreen:@"purple" animated:YES];
            }];
        }];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end
