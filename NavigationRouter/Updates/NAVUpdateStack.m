//
//  NAVUpdateStack.m
//  NavigationRouter
//

#import "NAVUpdateStack.h"
#import "NAVRouterUpdater.h"

@implementation NAVUpdateStack

- (void)prepareWithRoute:(NAVRoute *)route factory:(id<NAVRouterFactory>)factory
{
    self.controller = [factory controllerForRoute:route withAttributes:self.attributes];
}

- (void)performWithUpdater:(id<NAVRouterUpdater>)updater completion:(void (^)(BOOL))completion
{
    [updater performUpdate:self completion:completion];
}

@end
