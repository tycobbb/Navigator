//
//  NAVRouterFactory.h
//  Created by Ty Cobb on 7/17/14.
//

@import UIKit;
@import Foundation;

#import "NAVRoute.h"
#import "NAVAnimation.h"

@protocol NAVRouterFactory <NSObject>

/**
 @brief Constructs a view controller for a given route
 
 The parameterized route will contain the view controller's class as its destination, 
 which the factory should use to instantiate the view controller.
 
 The router's behavior is undefined if this method returns nil.
 
 @param route The route for this view controller
 @return A UIViewController instance
*/

- (UIViewController<NAVRouteDestination> *)controllerForRoute:(NAVRoute *)route;

/**
 @brief Locates the animation for a given route
 
 By default, the route will contain the animation as its destination, so the implementer
 may just return that animation. This provides the implementer the ability to return an
 animation dynamically for the route.
 
 @param route The route for the animation
 @return A NAVAnimation instance
*/

- (NAVAnimation *)animationForRoute:(NAVRoute *)route;

@end
