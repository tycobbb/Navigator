//
//  NAVAnimation.m
//  NavigationRouter
//

#import "NAVAnimation.h"
#import "NAVRouterFactory.h"
#import "NAVRouterUtilities.h"

@implementation NAVAnimation

# pragma mark - NAVRouteDestinatoin

- (void)updateWithAttributes:(id)attributes
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
    
    [self updateIsVisible:isVisible animated:animated completion:^(BOOL finished) {
        [self didFinishAnimationToVisible:isVisible];
        nav_call(completion)(finished);
    }];
}

# pragma mark - Lifecycle

- (void)prepareForAnimationWithFactory:(id<NAVRouterFactory>)factory
{

}

- (void)updateIsVisible:(BOOL)isVisible animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    
}

- (void)didFinishAnimationToVisible:(BOOL)isVisible
{
    [self.delegate animation:self didUpdateIsVisible:isVisible];
}

# pragma mark - Accessors

- (BOOL)completesAsynchronously
{
    return NO;
}

@end
