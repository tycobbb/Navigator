//
//  NAVTransitionBuilder_Private.h
//  Navigator
//

#import <YOLOKit/YOLO.h>
#import "NAVTransitionBuilder.h"
#import "NAVTransition.h"
#import "NAVRouterUtilities.h"

@protocol NAVTransitionBuilderDelegate;

@interface NAVTransitionBuilder ()
@property (weak  , nonatomic) id<NAVTransitionBuilderDelegate> delegate;
@property (assign, nonatomic) BOOL shouldEnqueue;
@end

@interface NAVTransitionBuilder (Output)

/**
 @brief Constructs a transition object from the source URL.
 
 The transformations will be applied in order to the source URL to generate the
 destination URL, and any data objects will be stored on the resultant transition's 
 attributes.
 
 @param block:source The transition's source URL
 
 @return A block that can be called to build a new transition instance
 */

- (NAVTransition *(^)(NAVURL *source))build;

@end

@protocol NAVTransitionBuilderDelegate <NSObject>

/**
 @brief Enqueues the transition builder for execution
 
 If the @c enqueued property is @c NO (the default), then the transition will attempt to
 run automatically.
*/

- (void)enqueueTransitionForBuilder:(NAVTransitionBuilder *)transitionBuilder;

@end
