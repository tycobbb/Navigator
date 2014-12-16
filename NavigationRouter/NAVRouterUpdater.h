//
//  NAVRouterUpdater.h
//  NavigationRouter
//

#import "NAVUpdateStack.h"

@protocol NAVRouterUpdater <NSObject>
- (void)performUpdate:(NAVUpdateStack *)update completion:(void(^)(BOOL finished))completion;
@end
