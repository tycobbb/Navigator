//
//  NAVUpdateStack.m
//  Navigator
//

#import "NAVUpdateStack.h"
#import "NAVRouterUpdater.h"

@implementation NAVUpdateStack

- (void)prepareWithRoute:(NAVRoute *)route factory:(id<NAVRouterFactory>)factory
{
    // only create a controller if showing something new
    if(self.type != NAVUpdateTypePop) {
        self.controller = [factory controllerForRoute:route];
    }
}

- (void)performWithUpdater:(id<NAVRouterUpdater>)updater completion:(void (^)(BOOL))completion
{
    [updater performUpdate:self completion:completion];
}

- (void)setController:(UIViewController<NAVRouteDestination> *)controller
{
    if(_controller == controller) {
        return;
    }
    
    _controller = controller;
    
    // update the new controller with this update's attributes
    [_controller updateWithAttributes:self.attributes];
}

@end
