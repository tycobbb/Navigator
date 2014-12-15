//
//  NAVDemoRouter.m
//  NavigationRouter
//

#import "NAVDemoRouter.h"
#import "NAVDemoViewControllers.h"
#import "NAVRouter_Subclass.h"

@implementation NAVDemoRouter

- (void)routes:(NAVRouteBuilder *)route
{
    route.to(NAVDemoRouteBlue).controller(NAVBlueViewController.class);
    route.to(NAVDemoRouteRed).controller(NAVRedViewController.class);
    route.to(NAVDemoRoutePurple).controller(NAVPurpleViewController.class).as(NAVRouteTypeModal);
}

@end
