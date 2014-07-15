//
//  NAVAppDelegate.m
//  NavigationRouter
//
//  Created by Ty Cobb on 7/14/14.
//  Copyright (c) 2014 Isobar. All rights reserved.
//

#import "NAVAppDelegate.h"
#import "NAVRouter.h"

@implementation NAVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NAVRouter *router = [NAVRouter new];
    
    [router updateRoutes:^(NAVRouteBuilder *route) {
        route.to(@"home").as(NAVRouteTypeStack);
        route.to(@"detail").as(NAVRouteTypeStack);
        route.to(@"register").as(NAVRouteTypeModal);
    }];
    
    return YES;
}

@end
