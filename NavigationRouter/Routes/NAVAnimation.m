//
//  NAVAnimation.m
//  NavigationRouter
//

#import "NAVAnimation.h"
#import "NAVRouterUtilities.h"

@implementation NAVAnimation

# pragma mark - NAVRouteDestinatoin

- (void)updateWithAttributes:(id)attributes
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
    [self setIsVisible:isVisible animated:NO completion:nil];
}

- (void)setIsVisible:(BOOL)isVisible animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    if(_isVisible == isVisible) {
        nav_call(completion)(YES);
        return;
    }
    
    _isVisible = isVisible;
    
    [self updatedIsVisible:isVisible animated:animated completion:^(BOOL finished) {
        [self.delegate animation:self didUpdateIsVisible:isVisible];
        nav_call(completion)(finished);
    }];
}

- (void)updatedIsVisible:(BOOL)isVisible animated:(BOOL)animated completion:(void (^)(BOOL))completion
{

}

@end
