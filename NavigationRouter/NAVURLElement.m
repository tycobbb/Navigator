//
//  NAVURLElement.m
//  Created by Ty Cobb on 7/20/14.
//

#import "NAVRouterImports.h"
#import "NAVURLElement.h"

@implementation NAVURLElement

- (instancetype)initWithKey:(NSString *)key
{
    if(self = [super init])
        _key = key;
    return self;
}

@end
