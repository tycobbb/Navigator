//
//  NAVAnimation.h
//  NavigationRouter
//

@import Foundation;

#import "NAVRouteDestination.h"

@interface NAVAnimation : NSObject

/**
 @brief Flag indicating whether the animator is visible
 
 Updating this flag will fire @c onPresentation and @c onDismissal events, but will not
 trigger any NAVAnimator callbacks. The animator should update this property after its
 animation is complete.
*/

@property (assign, nonatomic) BOOL isVisible;

/**
 @brief Executes the animation
 
 The animation will call its animator to perfrom the UI updates, and will do any necessary
 bookkeeping to keep the router and animator in sync.
 
 @param isVisible Flag indicating whether the animation is visible
*/

- (void)animateToVisible:(BOOL)isVisible;

/**
 @brief Registers a callback called when the animation transitions to isVisible
 
 After the callback is run, it is immediately destroyed. If multiple callbacks are required, then
 the the caller should re-register the callback inside its @c onPresentation: block.

 @param block The block to execute when the animation is presented
*/

- (void)onPresentation:(void(^)(void))block;

/**
 @brief Registers a callback called when the animation transitions to !isVisible
 
 After the callback is run, it is immediately destroyed. If multiple callbacks are required, then
 the the caller should re-register the callback inside its @c onDismissal: block.

 @param block The block to execute when the animation is dismissed
*/

- (void)onDismissal:(void(^)(void))block;

@end
