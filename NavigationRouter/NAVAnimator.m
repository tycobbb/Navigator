//
//  NAVAnimator.m
//  Created by Ty Cobb on 7/17/14.
//

#import "NAVAnimator.h"

@interface NAVAnimator ()
@property (strong, nonatomic) NSMutableArray *dismissalHandlers;
@end

@implementation NAVAnimator

- (void)transitionToVisible:(BOOL)isVisible animated:(BOOL)animated completion:(void(^)(BOOL))completion
{
    [self.delegate animator:self transitionToVisible:isVisible animated:animated completion:^(BOOL finished) {
        if(!isVisible)
            [self didCompleteDismissal];
        if(completion)
            completion(finished);
    }];
}

- (void)onDismissal:(void(^)(void))handler
{
    if(!self.dismissalHandlers)
        self.dismissalHandlers = [NSMutableArray new];
    [self.dismissalHandlers addObject:handler];
}

//
// Helpers
//

- (void)didCompleteDismissal
{
    for(void(^handler)(void) in self.dismissalHandlers)
        handler();
    self.dismissalHandlers = nil;
}

- (void)dealloc
{
    
}

@end
