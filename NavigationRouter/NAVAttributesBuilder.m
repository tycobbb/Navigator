//
//  NAVAttributesBuilder.m
//  NavigationRouter
//

#import "NAVAttributesBuilder.h"

@implementation NAVAttributesBuilder

- (NAVAttributes *)attributesFromUrl:(NAVURL *)url
{
    return nil;
}

# pragma mark - Chaining

- (NAVAttributesBuilder *(^)(NAVAttributesUrlTransformer))transform
{
    return nil;
}

- (NAVAttributesBuilder *(^)(id))object
{
    return nil;
}

- (NAVAttributesBuilder *(^)(id))handler
{
    return nil;
}

@end
