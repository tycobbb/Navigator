//
//  NAVRouterFactory.h
//  Created by Ty Cobb on 7/17/14.
//

@class NAVRouter, NAVRoute, NAVAnimator;

@protocol NAVRouterFactory <NSObject>
- (UIViewController *)viewControllerForRoute:(NAVRoute *)route;
- (NAVAnimator *)animatorForRoute:(NAVRoute *)route;
@end
