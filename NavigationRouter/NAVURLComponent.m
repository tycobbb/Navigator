//
//  NAVURLComponent.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURLComponent.h"

@implementation NAVURLComponent

- (instancetype)initWithKey:(NSString *)key index:(NSInteger)index
{
    if(self = [super initWithKey:key])
        _index = index;
    return self;
}

# pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    NAVURLComponent *copy = [super copyWithZone:zone];
    copy.index = self.index;
    return copy;
}

# pragma mark - Description

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@" %d: %@", (int)self.index, self.key];
}

# pragma mark - Equality

- (BOOL)isEqual:(id)object
{
    if(![object isKindOfClass:[NAVURLComponent class]])
        return NO;
    return [self.key isEqualToString:[object key]];
}

- (NSUInteger)hash
{
    return [self.key hash];
}

@end
