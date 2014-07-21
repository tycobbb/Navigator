//
//  NAVUpdateBuilder.m
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVUpdateBuilder.h"
#import "NAVUpdateStack.h"
#import "NAVUpdateAnimation.h"

#define NAVUpdateBuilderChain(_name) - (NAVUpdateBuilder *) _name { return self; }

@interface NAVUpdateBuilder ()
@property (strong, nonatomic) NSString *routeKey;
@property (assign, nonatomic) NAVUpdateType updateType;
@property (assign, nonatomic) NSInteger updateIndex;
@property (strong, nonatomic) NAVRoute *updateRoute;
@property (strong, nonatomic) NAVURLParameter *updateParameter;
@property (assign, nonatomic) BOOL updateIsAnimated;
@end

@implementation NAVUpdateBuilder

# pragma mark - Builder Options

- (NAVUpdateBuilder *(^)(NAVUpdateType))as
{
    return ^(NAVUpdateType type) {
        self.updateType = type;
        return self;
    };
}

- (NAVUpdateBuilder *(^)(NAVURLParameter *))parameter
{
    return ^(NAVURLParameter *parameter) {
        self.routeKey         = parameter.key;
        self.updateParameter  = parameter;
        self.updateIsAnimated = !(parameter.options & NAVParameterOptionsUnanimated);
        return self;
    };
}

- (NAVUpdateBuilder *(^)(NAVURLComponent *))component
{
    return ^(NAVURLComponent *component) {
        self.routeKey    = component.key;
        self.updateIndex = component.index;
        return self;
    };
}

- (NAVUpdate *(^)(void))build
{
    return ^{
        [self updateWithRoute:[self.delegate builder:self routeForKey:self.routeKey]];

        Class updateClass = [self updateClassForType:self.updateType];
        NAVUpdate *update = [updateClass updateWithType:self.updateType route:self.updateRoute];
        
        update.isAnimated = self.updateIsAnimated;
        
        if([update isKindOfClass:[NAVUpdateAnimation class]])
            [self buildAnimationSpecificProperties:(NAVUpdateAnimation *)update];
        else if([update isKindOfClass:[NAVUpdateStack class]])
            [self buildStackSpecificProperties:(NAVUpdateStack *)update];
        
        [self reset];
        
        return update;
    };
}

- (void)reset
{
    self.updateIndex = 0;
    self.updateType = NAVUpdateTypeUnknown;
    self.updateIsAnimated = YES;
    self.updateParameter = nil;
    self.updateRoute = nil;
    self.routeKey = nil;
}

//
// Type-specific Construction
//

- (void)buildAnimationSpecificProperties:(NAVUpdateAnimation *)update
{
    update.animator       = [[self.delegate factoryForBuilder:self] animatorForRoute:self.updateRoute];
    update.isAsynchronous = self.updateParameter.options & NAVParameterOptionsAsync;
    update.isVisible      = self.updateParameter.isVisible;
}

- (void)buildStackSpecificProperties:(NAVUpdateStack *)update
{
    update.viewController = [[self.delegate factoryForBuilder:self] viewControllerForRoute:self.updateRoute];
    update.index          = [self updateIndex];
}

//
// Helpers
//

- (void)updateWithRoute:(NAVRoute *)route
{
    self.updateRoute = route;
    if(!self.updateType)
        self.updateType = [self updateTypeForRoute:route];
}

- (NAVUpdateType)updateTypeForRoute:(NAVRoute *)route
{
    switch(route.type)
    {
        case NAVRouteTypeAnimation:
            return NAVUpdateTypeAnimation;
        case NAVRouteTypeModal:
            return NAVUpdateTypeModal;
        default:
            return NAVUpdateTypeUnknown;
    }
}

- (Class)updateClassForType:(NAVUpdateType)type
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
        default:
            NSAssert(false, @"cannot determine update class from this type: %d", type); return nil;
    }
}

# pragma mark - Empty Chainers

NAVUpdateBuilderChain(with);
NAVUpdateBuilderChain(and);

@end
