//
//  NAVUpdate.h
//  NavigationRouter
//

@import Foundation;

#import "NAVRoute.h"
#import "NAVAttributes.h"
#import "NAVRouterFactory.h"

typedef NS_ENUM(NSInteger, NAVUpdateType) {
    NAVUpdateTypeUnknown,
    NAVUpdateTypePush,
    NAVUpdateTypePop,
    NAVUpdateTypeReplace,
    NAVUpdateTypeAnimation,
};

@protocol NAVUpdateDelegate, NAVRouterUpdater;

@interface NAVUpdate : NSObject

/**
 @brief Provides the update information about how it should perform
*/

@property (weak, nonatomic) id<NAVUpdateDelegate> delegate;

/**
 @brief The type of this update
 
 If the update type is .Push, .Pop, or .Replace, then this update is a change to the
 view stack. The destination of the route should be a view controller class.
 
 IF the update type is .Animation, then this update is a change to a view independent
 of the view stack. The destination of this route should be a NAVAnimation.
*/

@property (nonatomic, readonly) NAVUpdateType type;

/**
 @brief The URL element assosciated to this update

 The URL element is used to determine the route assosciated with this update when
 it needs to be performed.
*/

@property (nonatomic, readonly) NAVURLElement *element;

/**
 @brief The attributes assosciated to this update
 
 The attributes will be delivered to the route's destination object during the update's
 execution.
*/

@property (nonatomic, readonly) NAVAttributes *attributes;

/**
 @brief Flag indicating whether or not to run the update animatedly
 
 This property may depend on the update's delegate, and will throw an exception if it's
 called before that point.
*/

@property (nonatomic, readonly) BOOL isAnimated;

/**
 @brief Flag indicating whether or not to run the update asynchronously
 
 Asynchronous updates will not block the subsequent update from being run. Currently,
 animation updates can be made asynchronous by passing the @c NAVParameterOptionsAsync 
 option when updating the parameter.
*/

@property (nonatomic, readonly) BOOL isAsynchronous;

/**
 @brief Flag indicating whether or not the update should complete asynchronously
 
 Certain updates, such as modals, won't be considered complete by the system until the next
 run-loop. The transition uses this to determine if it should complete on the next frame. 
*/

@property (nonatomic, readonly) BOOL completesAsynchrnously;

/**
 @brief Initializes a new update of the specified type

 All parameters are required. Failure to pass a valid value for one of the parameters
 results in an exception.
 
 @param type       The type of update
 @param element    The URL element assosciated with this update
 @param attributes The attribtues corresponding to this update
 
 @return A new update instance
*/

+ (instancetype)updateWithType:(NAVUpdateType)type element:(NAVURLElement *)element attributes:(NAVAttributes *)attributes;

/**
 @brief Provides the update a hook to configure itself before performing
 
 The route contains information about what controller to show or animations to run.
 
 @param route   A navigation route containing the destination information
 @param factory A factory for constructing the necessary components to execute the update
*/

- (void)prepareWithRoute:(NAVRoute *)route factory:(id<NAVRouterFactory>)factory;

/**
 @brief Performs the update with the given updater
 
 The update may or may not take advantage of the updater. It should call back the completion 
 when it's finished running.
 
 @param updater    The updater for interacting with the application outside the router
 @param completion A callback when the update finishes
*/

- (void)performWithUpdater:(id<NAVRouterUpdater>)updater completion:(void(^)(BOOL))completion;

@end

@protocol NAVUpdateDelegate <NSObject>

/**
 @brief Tells the update whether to animate
 
 The update still makes the final decision about whether to animate internally if this method 
 returns YES, but if it returns NO the update will not animate.
 
 @param update The update in question
 
 @return Whether or not the update should animate
*/

- (BOOL)shouldAnimateUpdate:(NAVUpdate *)update;

@end
