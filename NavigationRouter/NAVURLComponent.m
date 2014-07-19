//
//  NAVURLComponent.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURLComponent.h"

@implementation NAVURLComponent

- (instancetype)initWithComponent:(NSString *)component index:(NSInteger)index
{
    if(self = [super init])
    {
        _component = component;
        _index     = index;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if(![object isKindOfClass:[NAVURLComponent class]])
        return NO;
    return [self.component isEqualToString:[object component]];
}

- (NSUInteger)hash
{
    return [self.component hash];
}

@end
