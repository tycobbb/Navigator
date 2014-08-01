//
//  NAVRouterStoryboardFactory.m
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVRouterStoryboardFactory.h"
#import "NAVRoute.h"

@implementation NAVRouterStoryboardFactory

- (UIViewController *)controllerForRoute:(NAVRoute *)route withAttributes:(NAVAttributes *)attributes
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NAVDemoStoryboard" bundle:[NSBundle mainBundle]];
    NSString *identifier = [@"NAVDemoViewController" stringByAppendingString:[route.path capitalizedString]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    return viewController;
}

- (NAVAnimator *)animatorForRoute:(NAVRoute *)route withAttributes:(NAVAttributes *)attributes
{
    return nil;
}

@end
