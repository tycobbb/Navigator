//
//  NAVRouterFactory.h
//  Created by Ty Cobb on 7/17/14.
//

@import UIKit;
@import Foundation;

#import "NAVRoute.h"
#import "NAVAttributes_legacy.h"
#import "NAVAnimator.h"

@protocol NAVRouterFactory <NSObject>
- (UIViewController *)controllerForRoute:(NAVRoute *)route withAttributes:(NAVAttributes_legacy *)attributes;
- (NAVAnimator *)animatorForRoute:(NAVRoute *)route withAttributes:(NAVAttributes_legacy *)attributes;
@end
