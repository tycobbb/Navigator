//
//  NAVRouterStoryboardFactory.m
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVRouterStoryboardFactory.h"
#import "NAVRoute.h"

@implementation NAVRouterStoryboardFactory

- (UIViewController *)viewControllerForRoute:(NAVRoute *)route
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NAVDemoStoryboard" bundle:[NSBundle mainBundle]];
    NSString *identifier = [@"NAVDemoViewController" stringByAppendingString:[route.component capitalizedString]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    return viewController;
}

- (NAVAnimator *)animatorForRoute:(NAVRoute *)route
{
    return nil;
}

@end
