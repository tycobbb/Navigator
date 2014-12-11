//
//  NAVTransition.h
//  NavigationRouter
//

@import Foundation;

#import "NAVUpdate.h"
#import "NAVRoute.h"

@protocol NAVTransitionDelegate;

@interface NAVTransition : NSObject

/**
 @brief Receives updates about the transitions lifecycle
 
 The transition uses its delegate to pull information necessary to build its updates
 and to report status during execution.
*/

@property (weak, nonatomic) id<NAVTransitionDelegate> delegate;

/**
 @brief The view updates to run for this transition
    
 The updates are stored sequentially, and each update encapsulates the information
 necessary to perform one interface update.
*/

@property (nonatomic, readonly) NSArray *updates;

/**
 @brief Specifies whether all of the updates in the transition should be animated
 
 If the value is false, then all updates will be considered unanimated. However, if
 it's true individual updates may still override this behavior to prevent animation.
*/

@property (assign, nonatomic) BOOL isAnimated;

/**
 @brief Block called once the transition has completed
 
 Every update in the transition must complete first before the transition as a whole
 is considered complete.
*/

@property (copy, nonatomic) void(^completion)(void);

/**
 @brief Desginated initializer. Creates a new transition with the given attributes builder
 
 The attributes at this point should be incomplete--namely, missing a source URL. The
 necessary information to complete the attributes should be passed in @c startWithUrl:.
 
 @param attributes The attributes builder for the transition to run
 
 @return A new NAVTransition instance for the specified attributes
*/

- (instancetype)initWithAttributesBuilder:(NAVAttributesBuilder *)attributesBuilder;

/**
 @brief Starts the transition, performing its updates
 
 The transition populates its attributes appropriately and then generates and runs a sequence of
 interface updates.
 
 @param url The URL to transition from, which will be used to determine the list of updates
*/

- (void)startFromUrl:(NAVURL *)url;

@end

@protocol NAVTransitionDelegate <NSObject>

/**
 @brief Hook for the delegate to access routes
 
 The transition asks for the routes in order to execute its updates properly. If no route
 is found, the transition throw's an exception.
 
 @param transition The transition asking for the route
 @param element    The element used to access the route
 
 @return A route correpsonding to this element, or nil
*/

- (NAVRoute *)transition:(NAVTransition *)transition routeForUrlElement:(NAVURLElement *)element;

/**
 @brief Notifies the delegate that the transition finished
 
 The transition completes once all the updates have finished running, or immediately if it
 generated no updates.
 
 @param transition The transition that called this delegate method
*/

- (void)transitionDidComplete:(NAVTransition *)transition;

@end
