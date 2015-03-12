//
//  NAVRouterUtilities.h
//  Navigator
//

@import Foundation;

#import "NAVRouterConstants.h"

/**
 @brief A custom assert function that accepts an exception type
 
 @param condition The condition to validate
 @param name      The name of the exception
 @param format    The format string for the exception's @c reason
 @param ...       The format variables for the exception's @c reason
*/

extern void NAVAssert(BOOL condition, NSString *name, NSString *format, ...);

/**
 @brief Dispatches the given block based on a condition
 
 If @c async is YES, it will be dispatched asynchronously on the given queue. Otherwise,
 the block is called synchronously on the queue.
 
 @param async Whether or not to call the block asynchronously
 @param queue The queue to call the block on
 @param block The block to call
*/

extern void optionally_dispatch_async(BOOL async, dispatch_queue_t queue, void(^block)(void));

#define nav_call(_block) if(_block) _block
