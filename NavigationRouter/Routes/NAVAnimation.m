//
//  NAVAnimation.m
//  NavigationRouter
//

#import "NAVAnimation.h"

@implementation NAVAnimation

- (void)animateToVisible:(BOOL)isVisible
{
    
}

# pragma mark - Listeners

- (void)onPresentation:(void (^)(void))block
{
    
}

- (void)onDismissal:(void (^)(void))block
{
    
}

# pragma mark - Setters

- (void)setIsVisible:(BOOL)isVisible
{
    if(_isVisible == isVisible) {
        return;
    }
    
    _isVisible = isVisible;
}

@end
