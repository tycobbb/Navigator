//
//  NAVRouterFactory.h
//  Created by Ty Cobb on 7/17/14.
//

@import UIKit;
@import Foundation;

#import "NAVRoute.h"
#import "NAVAttributes.h"
#import "NAVAnimation.h"

@protocol NAVRouterFactory <NSObject>
- (UIViewController<NAVRouteDestination> *)controllerForRoute:(NAVRoute *)route withAttributes:(NAVAttributes *)attributes;
- (NAVAnimation *)animationForRoute:(NAVRoute *)route withAttributes:(NAVAttributes *)attributes;
@end
