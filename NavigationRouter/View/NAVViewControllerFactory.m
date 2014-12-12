//
//  NAVViewControllerFactory.m
//  NavigationRouter
//

#import "NAVViewControllerFactory.h"
#import "NAVViewController.h"

@implementation NAVViewControllerFactory

- (UIViewController *)controllerForRoute:(NAVRoute *)route withAttributes:(NAVAttributes *)attributes
{
    // destination should be a controller class in this case
    Class<NAVViewController> klass = route.destination;
    
    // create thew view controller, and update it with the attributes
    NAVViewController *controller = [klass instance];
    
    return controller;
}

- (NAVAnimation *)animationForRoute:(NAVRoute *)route withAttributes:(NAVAttributes *)attributes
{
    return route.destination;
}

@end
