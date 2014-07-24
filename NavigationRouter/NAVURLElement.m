//
//  NAVURLElement.m
//  Created by Ty Cobb on 7/20/14.
//

#import "NAVURLElement.h"

@implementation NAVURLElement

- (instancetype)initWithKey:(NSString *)key
{
    if(self = [super init])
        _key = key;
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    NAVURLElement *copy = [self.class new];
    copy.key = self.key;
    return copy;
}

@end
