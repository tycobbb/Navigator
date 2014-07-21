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
        route.to(@"blue").as(NAVRouteTypeModal);
        route.to(@"purple").as(NAVRouteTypeModal);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NAVAttributes *attributes = [self.router.attributesBuilder toPath:@"/red/blue/"].build;
    [self.router transitionWithAttributes:attributes animated:YES completion:^{
        NAVAttributes *attributes = [self.router.attributesBuilder toPath:@"green"].build;
        [self.router transitionWithAttributes:attributes animated:YES completion:^{
            NAVAttributes *attributes = [self.router.attributesBuilder popBack:1].build;
            [self.router transitionWithAttributes:attributes animated:YES completion:nil];
        }];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end
