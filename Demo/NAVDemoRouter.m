//
//  NAVDemoRouter.m
//  Navigator
//

#import "NAVDemoRouter.h"
#import "NAVDemoViewControllers.h"
#import "NAVRouter_Subclass.h"

@implementation NAVDemoRouter

+ (NSString *)scheme
{
    return @"demo";
}

- (void)routes:(NAVRouteBuilder *)route
{
    route.to(NAVDemoRouteBlue).controller(NAVBlueViewController.class);
    route.to(NAVDemoRouteRed).controller(NAVRedViewController.class);
    route.to(NAVDemoRoutePurple).controller(NAVPurpleViewController.class).as(NAVRouteTypeModal);
}

@end
