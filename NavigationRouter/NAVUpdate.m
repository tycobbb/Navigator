//
//  NAVUpdate.m
//  Created by Ty Cobb on 7/17/14.
//

#import "NAVUpdate.h"
#import "NAVAnimator.h"

@interface NAVUpdateStack : NAVUpdate
@property (strong, nonatomic, readonly) UIViewController *viewController;
@end

@interface NAVUpdateAnimation : NAVUpdate
@property (strong, nonatomic, readonly) NAVAnimator *animator;
@end

@implementation NAVUpdate

+ (instancetype)updateWithType:(NAVUpdateType)type route:(NAVRoute *)route
{
    Class subclass = [self subclassForType:type];
    return [[subclass alloc] initWithType:type route:route];
}

- (instancetype)initWithType:(NAVUpdateType)type route:(NAVRoute *)route
{
    if(self = [super init])
    {
        _type    = type;
        _route   = route;
    }
    
    return self;
}

- (void)configureWithFactory:(id<NAVRouterFactory>)factory
{
    
}

- (void)executeWithUpdater:(id<NAVRouterUpdater>)updater
{
    
}

//
// Helpers
//

+ (Class)subclassForType:(NAVUpdateType)type
{
    switch(type)
    {
        case NAVUpdateTypePop:
        case NAVUpdateTypePush:
        case NAVUpdateTypeReplace:
            return [NAVUpdateStack class];
        case NAVUpdateTypeAnimation:
        case NAVUpdateTypeModal:
            return [NAVUpdateAnimation class];
    }
}

@end

@implementation NAVUpdateStack

- (void)configureWithFactory:(id<NAVRouterFactory>)factory
{
    [super configureWithFactory:factory];
    _viewController = [factory viewControllerForRoute:self.route];
}

- (void)executeWithUpdater:(id<NAVRouterUpdater>)updater completion:(void(^)(BOOL))completion
{
    
}

@end

@implementation NAVUpdateAnimation

- (void)configureWithFactory:(id<NAVRouterFactory>)factory
{
    [super configureWithFactory:factory];
    _animator = [factory animatorForRoute:self.route];
}

- (void)executeWithUpdater:(id<NAVRouterUpdater>)updater completion:(void(^)(BOOL))completion
{
    
}

@end
