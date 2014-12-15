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
    // determine transition type
    BOOL isVisible  = [self.parameter isVisible];
    BOOL isAnimated = [self.delegate shouldAnimateUpdate:self] && self.parameter.isAnimated;
    
    [self.animation setIsVisible:isVisible animated:isAnimated completion:completion];
}

# pragma mark - Accessors

- (NAVURLParameter *)parameter
{
    return (NAVURLParameter *)self.element;
}

@end
