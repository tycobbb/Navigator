//
//  NAVUpdateAnimation.m
//  Navigator
//

#import "NAVUpdateAnimation.h"
#import "NAVAnimationModal.h"
#import "NAVRouterUtilities.h"

@interface NAVUpdateAnimation ()
@property (nonatomic, readonly) NAVURLParameter *parameter;
@end

@implementation NAVUpdateAnimation

- (void)prepareWithRoute:(NAVRoute *)route factory:(id<NAVRouterFactory>)factory
{
    // create the animation for this update
    NAVAnimation *animation = [self animationForRoute:route factory:factory];
    NAVAssert(animation != nil, NAVExceptionInvalidRoute, @"failed to create an animation for route: %@", route);
    
    // allow the animation to do any internal preperation
    [animation prepareForAnimationWithFactory:factory];
    [animation updateWithAttributes:self.attributes];
   
    // store the animation
    self.animation = animation;
}

- (void)performWithUpdater:(id<NAVRouterUpdater>)updater completion:(void(^)(BOOL))completion
{
    [self.animation setIsVisible:self.parameter.isVisible animated:self.isAnimated completion:completion];
}

//
// Helpers
//

- (NAVAnimation *)animationForRoute:(NAVRoute *)route factory:(id<NAVRouterFactory>)factory
{
    // see if our factory has anything first
    NAVAnimation *animation = [factory animationForRoute:route];
    
    // if not and if we can automatically create the animation dynamically, then do so
    if(!animation && (self.parameter.options & NAVParameterOptionsModal)) {
        animation = [[NAVAnimationModal alloc] initWithRoute:route];
    }

    return animation;
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
