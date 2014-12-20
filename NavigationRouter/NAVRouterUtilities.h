//
//  NAVRouterUtilities.h
//  NavigationRouter
//

@import Foundation;

extern void NAVAssert(BOOL condition, NSString *name, NSString *format, ...);
extern void optionally_dispatch_async(BOOL async, dispatch_queue_t queue, void(^block)(void));

#define nav_call(_block) if(_block) _block
