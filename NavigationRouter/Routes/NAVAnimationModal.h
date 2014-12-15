//
//  NAVAnimationModal.h
//  NavigationRouter
//

#import "NAVAnimation.h"
#import "NAVRoute.h"

@interface NAVAnimationModal : NAVAnimation

/**
 @brief Initializes the animation with a route
 
 The route's destination should be a controller class--if it isn't, the animation will throw
 an exception. The modal animation will automatically create instances of this view controller
 during presentation.
 
 @param route The route to create the modal's view controller from

 @return A new modal animation instance for this controller route
*/

- (instancetype)initWithRoute:(NAVRoute *)route;

@end
