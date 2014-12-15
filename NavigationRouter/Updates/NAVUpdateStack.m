//
//  NAVUpdateStack.m
//  NavigationRouter
//

#import "NAVUpdateStack.h"
#import "NAVRouterUpdater.h"

@implementation NAVUpdateStack

- (void)prepareWithRoute:(NAVRoute *)route factory:(id<NAVRouterFactory>)factory
{
    [self setController:[factory controllerForRoute:route]];
    [self.controller updateWithAttributes:self.attributes];
}

- (void)performWithUpdater:(id<NAVRouterUpdater>)updater completion:(void (^)(BOOL))completion
{
    [updater performUpdate:self completion:completion];
}

@end
