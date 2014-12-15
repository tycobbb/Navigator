//
//  NAVRouterUtilities.h
//  NavigationRouter
//

@import Foundation;

extern void NAVAssert(BOOL condition, NSString *name, NSString *format, ...);

#define nav_call(_block) if(_block) _block
