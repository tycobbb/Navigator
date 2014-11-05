//
//  NAVURLElement_legacy.m
//  Created by Ty Cobb on 7/20/14.
//

#import "NAVURLElement_legacy.h"

@implementation NAVURLElement_legacy

- (instancetype)initWithKey:(NSString *)key
{
    if(self = [super init])
        _key = key;
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    NAVURLElement_legacy *copy = [self.class new];
    copy.key = self.key;
    return copy;
}

@end
