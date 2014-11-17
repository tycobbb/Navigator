//
//  NAVRouterUpdater.h
//  NavigationRouter
//

#import "NAVUpdate.h"

@protocol NAVRouterUpdater <NSObject>
- (void)performUpdate:(NAVUpdate *)update completion:(void(^)(BOOL finished))completion;
@end
