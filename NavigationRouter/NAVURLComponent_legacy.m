//
//  NAVURLComponent_legacy.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURLComponent_legacy.h"

@implementation NAVURLComponent_legacy

- (instancetype)initWithKey:(NSString *)key index:(NSInteger)index
{
    if(self = [super initWithKey:key])
        _index = index;
    return self;
}

# pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    NAVURLComponent_legacy *copy = [super copyWithZone:zone];
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
    if(![object isKindOfClass:[NAVURLComponent_legacy class]])
        return NO;
    return [self.key isEqualToString:[object key]];
}

- (NSUInteger)hash
{
    return [self.key hash];
}

@end
