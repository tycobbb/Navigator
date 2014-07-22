//
//  NAVUpdateAnimation.m
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVUpdateAnimation.h"
#import "NAVAnimatorModal.h"

@implementation NAVUpdateAnimation

- (void)performWithUpdater:(id<NAVRouterUpdater>)updater completion:(void (^)(BOOL))completion
{
//    if(!self.animator && self.type == NAVUpdateTypeModal)
//        self.animator = [NAVAnimatorModal new];
    [self.animator transitionToVisible:self.isVisible animated:self.isAnimated completion:completion];
}

@end
