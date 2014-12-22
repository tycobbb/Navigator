//
//  NAVRouterUpdater.h
//  NavigationRouter
//

#import "NAVUpdateStack.h"

@protocol NAVRouterUpdater <NSObject>

/**
 @brief Performs the view changes for a given stack update
 
 The update can either be a replace, a push, or a pop. If it's a replace or push, it will
 contain a view controller instance that the updater can use to perform its view transition.
 If it's a pop, the update's URL component will contain the index to pop to.
 
 The updater is responsible for calling the completion when the update finishes, and doing
 so will cause the transition to proceed to either the next update or complete.
 
 @param update     The update to perform
 @param completion A callback when the updater finishes performing its view transition
*/

- (void)performUpdate:(NAVUpdateStack *)update completion:(void(^)(BOOL finished))completion;

@end
