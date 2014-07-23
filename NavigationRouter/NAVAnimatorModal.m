//
//  NAVAnimatorModal.m
//  Created by Ty Cobb on 7/22/14.
//

#import "NAVAnimatorModal.h"

@interface NAVAnimatorModal () <NAVAnimatorDelegate> @end

@implementation NAVAnimatorModal

- (id)init
{
    if(self = [super init])
        self.delegate = self;
    return self;
}

- (void)animator:(NAVAnimator *)animator transitionToVisible:(BOOL)isVisible animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    void(^modalCompletion)(void) = ^{
        if(completion)
            completion(YES);
    };
    
    if(!isVisible)
        [self.viewController dismissViewControllerAnimated:animated completion:modalCompletion];
    else
    {
        UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        [controller presentViewController:self.viewController animated:YES completion:modalCompletion];
    }
}

@end
