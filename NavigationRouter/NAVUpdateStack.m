//
//  NAVUpdateStack.m
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVRouterImports.h"
#import "NAVUpdateStack.h"

@implementation NAVUpdateStack

- (void)performWithUpdater:(id<NAVRouterUpdater>)updater completion:(void(^)(BOOL))completion
{
    switch(self.type)
    {
        case NAVUpdateTypeReplace:
            [updater performReplace:self withViewController:self.viewController completion:completion]; break;
        case NAVUpdateTypePush:
            [updater performPush:self withViewController:self.viewController withCompletion:completion]; break;
        case NAVUpdateTypePop:
            [updater performPop:self toIndex:self.index withCompletion:completion]; break;
        default:
            NSAssert(false, @"can't handle other update types in a stack update"); break;
    }
}

@end
