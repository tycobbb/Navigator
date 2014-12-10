//
//  NAVUpdateBuilder.m
//  NavigationRouter
//

#import "NAVUpdateBuilder.h"

@interface NAVUpdateBuilder ()
@property (assign, nonatomic) NAVUpdateType typeB;
@property (strong, nonatomic) NAVURLElement *elementB;
@property (strong, nonatomic) NAVAttributes *attributesB;
@end

@implementation NAVUpdateBuilder

- (instancetype)init
{
    if(self = [super init]) {
        [self reset];
    }
    
    return self;
}

- (NAVUpdateBuilder *(^)(NAVURLComponent *))component
{
    return ^(NAVURLComponent *component) {
        self.elementB = component;
        return self;
    };
}

- (NAVUpdateBuilder *(^)(NAVURLParameter *))parameter
{
    return ^(NAVURLParameter *parameter) {
        self.elementB = parameter;
        self.typeB = NAVUpdateTypeAnimation;
        return self;
    };
}

- (NAVUpdateBuilder *(^)(NAVUpdateType))type
{
    return ^(NAVUpdateType type) {
        self.typeB = type;
        return self;
    };
}

- (NAVUpdateBuilder *(^)(NAVAttributes *))attributes
{
    return ^(NAVAttributes *attributes) {
        self.attributesB = attributes;
        return self;
    };
}

- (NAVUpdate *)build
{
    NSAssert(self.typeB, @"Update builder must have an update type");
    NSAssert(self.elementB, @"Update builder must have an element");
    NSAssert(self.attributesB, @"Update builder must have attributes");
    
    // create the update
    NAVUpdate *update = [NAVUpdate new];
    update.type = self.typeB;
    update.element = self.elementB;
    update.attributes = self.attributesB;
    
    // reset our state, and return the update
    [self reset];
    
    return update;
}

//
// Helpers
//

- (void)reset
{
    self.typeB = NAVUpdateTypeUnknown;
    self.elementB = nil;
    self.attributesB = nil;
}

@end
