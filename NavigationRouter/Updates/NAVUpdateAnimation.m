//
//  NAVUpdateAnimation.m
//  NavigationRouter
//

#import "NAVUpdateAnimation.h"

@interface NAVUpdateAnimation ()
@property (nonatomic, readonly) NAVURLParameter *parameter;
@end

@implementation NAVUpdateAnimation

- (void)prepareWithRoute:(NAVRoute *)route factory:(id<NAVRouterFactory>)factory
{
    // get the animation from the factory
    NAVAnimation *animation = [factory animationForRoute:route];
    
    // allow the animation to do any internal preperation
    [animation prepareForAnimationWithFactory:factory];
    [animation updateWithAttributes:self.attributes];
    
    self.animation = animation;
}

- (void)performWithUpdater:(id<NAVRouterUpdater>)updater completion:(void(^)(BOOL))completion
{
    [self.animation setIsVisible:self.parameter.isVisible animated:self.isAnimated completion:completion];
}

# pragma mark - Accessors

- (BOOL)isAnimated
{
    return super.isAnimated && self.parameter.isAnimated;
}

- (BOOL)isAsynchronous
{
    return self.parameter.isAsynchronous;
}

- (BOOL)completesAsynchrnously
{
    return self.animation.completesAsynchronously;
}

- (NAVURLParameter *)parameter
{
    return (NAVURLParameter *)self.element;
}

@end
