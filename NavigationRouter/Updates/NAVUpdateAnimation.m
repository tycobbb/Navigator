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
    // allow the factory first pass at creating the animation
    NAVAnimation *animation = [factory animationForRoute:route withAttributes:self.attributes];
    
    if(!animation) {
        
    }
    
    self.animation = animation;
}

- (void)performWithUpdater:(id<NAVRouterUpdater>)updater completion:(void (^)(BOOL))completion
{
    // determine transition
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
