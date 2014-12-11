//
//  NAVUpdate.m
//  NavigationRouter
//

#import "NAVUpdate.h"

@implementation NAVUpdate

- (instancetype)initWithType:(NAVUpdateType)type element:(NAVURLElement *)element attributes:(NAVAttributes *)attributes
{
    NSParameterAssert(type);
    NSParameterAssert(element);
    NSParameterAssert(attributes);
    
    if(self = [super init]) {
        _type = type;
        _element = element;
        _attributes = attributes;
    }
    
    return self;
}

@end
