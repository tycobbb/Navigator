//
//  NAVDemoAnimation.m
//  Navigator
//

#import "NAVDemoAnimation.h"

@implementation NAVDemoAnimation

- (void)updateIsVisible:(BOOL)isVisible animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    [UIView animateWithDuration:0.4f delay:0.0f usingSpringWithDamping:0.75f initialSpringVelocity:0.0f options:0 animations:^{
        self.animatingView.transform = CGAffineTransformMakeTranslation(isVisible ? 100.0f : 0.0f, 0.0f);
    } completion:completion];
}

@end
