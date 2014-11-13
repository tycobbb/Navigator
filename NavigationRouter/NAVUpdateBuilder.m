//
//  NAVUpdateBuilder.m
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVUpdateBuilder.h"
#import "NAVUpdateStack.h"
#import "NAVUpdateAnimation.h"
#import "NAVAnimatorModal.h"

#define NAVUpdateBuilderChain(_name) - (NAVUpdateBuilder *) _name { return self; }

@interface NAVUpdateBuilder ()
@property (strong, nonatomic) NSString *routeKey;
@property (assign, nonatomic) NAVUpdateType updateType;
@property (assign, nonatomic) NSInteger updateIndex;
@property (strong, nonatomic) NAVRoute *updateRoute;
@property (strong, nonatomic) NAVAttributes_legacy *updateAttributes;
@property (strong, nonatomic) NAVURLParameter_legacy *updateParameter;
@property (assign, nonatomic) BOOL updateIsAnimated;
@end

@implementation NAVUpdateBuilder

# pragma mark - Options

- (NAVUpdateBuilder *)asType:(NAVUpdateType)type
{
    self.updateType = type;
    return self;
}

- (NAVUpdateBuilder *)withParameter:(NAVURLParameter_legacy *)parameter
{
    self.routeKey         = parameter.key;
    self.updateParameter  = parameter;
    self.updateIsAnimated = !(parameter.options & NAVParameterOptions_legacyUnanimated);
    return self;
}

- (NAVUpdateBuilder *)withComponent:(NAVURLComponent_legacy *)component
{
    self.routeKey    = component.key;
    self.updateIndex = component.index;
    return self;
}

- (NAVUpdateBuilder *)withAttributes:(NAVAttributes_legacy *)attributes
{
    self.updateAttributes = attributes;
    return self;
}

- (NAVUpdateBuilder *(^)(NAVUpdateType))as
{
    return ^(NAVUpdateType type) {
        return [self asType:type];
    };
}

- (NAVUpdateBuilder *(^)(NAVURLParameter_legacy *))parameter
{
    return ^(NAVURLParameter_legacy *parameter) {
        return [self withParameter:parameter];
    };
}

- (NAVUpdateBuilder *(^)(NAVURLComponent_legacy *))component
{
    return ^(NAVURLComponent_legacy *component) {
        return [self withComponent:component];
    };
}

- (NAVUpdateBuilder *(^)(NAVAttributes_legacy *))attributes
{
    return ^(NAVAttributes_legacy *attributes) {
        return [self withAttributes:attributes];
    };
}

# pragma mark - Construction

- (NAVUpdate *)build
{
    [self configurePropertiesForRoute:[self.delegate builder:self routeForKey:self.routeKey]];

    Class updateClass = [self updateClassForType:self.updateType];
    NAVUpdate *update = [updateClass updateWithType:self.updateType route:self.updateRoute];
    
    update.isAnimated = self.updateIsAnimated;
    update.attributes = self.updateAttributes;
    
    if([update isKindOfClass:[NAVUpdateAnimation class]])
        [self buildAnimationSpecificProperties:(NAVUpdateAnimation *)update];
    else if([update isKindOfClass:[NAVUpdateStack class]])
        [self buildStackSpecificProperties:(NAVUpdateStack *)update];
    
    [self reset];
    
    return update;
}

- (void)reset
{
    self.updateIndex = 0;
    self.updateType = NAVUpdateTypeUnknown;
    self.updateIsAnimated = YES;
    self.updateAttributes = nil;
    self.updateParameter = nil;
    self.updateRoute = nil;
    self.routeKey = nil;
}

//
// Type-specific Construction
//

- (void)buildStackSpecificProperties:(NAVUpdateStack *)update
{
    update.index          = [self updateIndex];
    update.viewController = [self.delegate builder:self controllerForUpdate:update];
}

- (void)buildAnimationSpecificProperties:(NAVUpdateAnimation *)update
{
    update.isAsynchronous = self.updateParameter.options & NAVParameterOptions_legacyAsync;
    update.isVisible      = self.updateParameter.isVisible;
    update.animator       = [self.delegate builder:self animatorForUpdate:update];
}

//
// Helpers
//

- (void)configurePropertiesForRoute:(NAVRoute *)route
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
            NSAssert(false, @"cannot determine update class from this type: %d", (int)type); return nil;
    }
}

# pragma mark - Empty Chainers

NAVUpdateBuilderChain(with);
NAVUpdateBuilderChain(and);

@end
