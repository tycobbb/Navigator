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
    // if we're not asynchronous, the animation blocks the next operation
    if(!self.isAsynchronous) {
        [self performWithCompletion:completion];
    }
    // otherwise dispatch the animation and complete right away
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performWithCompletion:nil];
        });
        nav_call(completion)(YES);
    }
}

//
// Helpers
//

- (void)performWithCompletion:(void(^)(BOOL))completion
{
    [self.animation setIsVisible:self.parameter.isVisible animated:self.isAnimated completion:completion];
}

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
