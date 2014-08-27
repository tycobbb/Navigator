//
//  NAVRouter+Pathing.h
//  Created by Ty Cobb on 7/23/14.
//

#import "NAVRouter.h"

@interface NAVRouter (Pathing)

/**
 @brief Convenience method for transitioning to a new root screen
 
 Builds up a new URL of the form "<scheme>://<path>" and then performs a transition to that new URL.
 
 @param path The root path to switch to
*/

- (void)transitionToRoot:(NSString *)path;

/**
 @brief Convenience method for pushing a new screen onto the navigation stack
 
 Builds up a new URL of by appending the parameterized path to the router's current URL, and then transitions
 to that new URL.
 
 @param path The subpath to push onto the stack.
*/

- (void)transitionToPath:(NSString *)path;

/**
 @brief Convenience method for pushing a new screen onto the navigation stack
 
 Builds up a new URL of by appending the parameterized path to the router's current URL, and then transitions
 to that new URL.
 
 @param path  The subpath to push onto the stack.
 @param model The model to provide to the view controller
*/

- (void)transitionToPath:(NSString *)path withModel:(id)model;

/**
 @brief Convenience method for popping the last screen off the navigation stack
 
 Builds up a new URL of by appending removing the last component from the router's current URL, and then
 transitions to that new URL.
*/

- (void)transitionBack;

/**
 @brief Convenience method for triggering a presentation animation/modal
 
 Builds up a new URL of by updating or adding the value for the parameterized screen's state, ie 
 "<base>?<screen>=<state>", and then transitions to that new URL.
 
 @param screen   The path of the screen to present
 @param animated Flag indicating whether or not the transition is animated.=
*/

- (void)presentScreen:(NSString *)screen animated:(BOOL)animated;

/**
 @brief Convenience method for triggering an animation/presenting a modal
 
 Builds up a new URL of by updating or adding the value for the parameterized screen's state, ie
 "<base>?<screen>=<state>", and then transitions to that new URL.
 
 @param screen   The path of the screen to present
 @param animated Flag indicating whether or not the transition is animated.=
 @param model    The model to provide to the view controller
*/

- (void)presentScreen:(NSString *)screen animated:(BOOL)animated withModel:(id)model;

/**
 @brief Convenience method for triggering a dismissal animation/modal
 
 Builds up a new URL of by updating or removing the value for the parameterized screen's state, ie
 "<base>?<screen>=<state>", and then transitions to that new URL.
 
 @param screen   The path of the screen to dismiss
 @param animated Flag indicating whether or not the transition is animated.
*/

- (void)dismissScreen:(NSString *)screen animated:(BOOL)animated;

/**
 @brief Convenience method for updating an animated screens state.
 
 Builds up a new URL of by updating the value for the parameterized screen's state, ie
 "<base>?<screen>=<state>", and then transitions to that new URL.
 
 @param screen  The path of the screen to dismiss
 @param options Options indicating how to resolve the animation
 @param model   The model to provide to the view controller
*/

- (void)updateParameter:(NSString *)parameter withOptions:(NAVParameterOptions)options model:(id)model;

@end
