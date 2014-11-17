//
//  NAVUpdateBuilder.m
//  NavigationRouter
//

#import "NAVUpdateBuilder.h"

@interface NAVUpdateBuilder ()

@end

@implementation NAVUpdateBuilder

- (NAVUpdateBuilder *(^)(NAVURLComponent *))component
{
    return ^(NAVURLComponent *component) {
        return self;
    };
}

- (NAVUpdateBuilder *(^)(NAVURLParameter *))parameter
{
    return ^(NAVURLParameter *parameter) {
        return self;
    };
}

- (NAVUpdateBuilder *(^)(NAVUpdateType))type
{
    return ^(NAVUpdateType type) {
        return self;
    };
}

- (NAVUpdateBuilder *(^)(NAVAttributes *))attributes
{
    return ^(NAVAttributes *attributes) {
        return self;
    };
}

- (NAVUpdate *)build
{
    return nil;
}

@end
