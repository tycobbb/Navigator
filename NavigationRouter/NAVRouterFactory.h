//
//  NAVRouterFactory.h
//  Created by Ty Cobb on 7/17/14.
//

@import UIKit;
@import Foundation;

@class NAVRouter, NAVRoute, NAVAnimator;

@protocol NAVRouterFactory <NSObject>
- (UIViewController *)viewControllerForRoute:(NAVRoute *)route;
- (NAVAnimator *)animatorForRoute:(NAVRoute *)route;
@end
