//
//  NAVAnimator.m
//  Created by Ty Cobb on 7/17/14.
//

#import "NAVRouterImports.h"
#import "NAVAnimator.h"

@implementation NAVAnimator

- (void)transitionToVisible:(BOOL)isVisible animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    [self.delegate animator:self transitionToVisible:isVisible animated:animated completion:completion];
}

@end
