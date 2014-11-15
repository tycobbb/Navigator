//
//  NAVAttributesBuilder.m
//  NavigationRouter
//

#import "NAVAttributesBuilder.h"
#import "NAVAttributes.h"

@implementation NAVAttributesBuilder

- (NAVAttributes *(^)(NAVURL *))build
{
    return ^(NAVURL *source) {
        return (NAVAttributes *)nil;
    };
}

# pragma mark - Chaining

- (NAVAttributesBuilder *(^)(NAVAttributesUrlTransformer))transform
{
    return ^(NAVAttributesUrlTransformer transformer) {
        return self;
    };
}

- (NAVAttributesBuilder *(^)(id))object
{
    return ^(id object) {
        return self;
    };
}

- (NAVAttributesBuilder *(^)(id))handler
{
    return ^(id handler) {
        return self;
    };
}

@end
