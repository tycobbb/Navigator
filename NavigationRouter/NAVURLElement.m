//
//  NAVURLElement.m
//  NavigationRouter
//
//  Created by Ty Cobb on 11/4/14.
//
//

#import "NAVURLElement.h"

@implementation NAVURLElement

- (instancetype)initWithKey:(NSString *)key
{
    if(self = [super init]) {
        _key = key;
    }
    
    return self;
}

@end

@implementation NAVURLComponent

- (instancetype)initWithKey:(NSString *)key data:(NSString *)data index:(NSInteger)index
{
    if(self = [super initWithKey:key]) {
        _data  = data;
        _index = index;
    }
    
    return self;
}

@end

@implementation NAVURLParameter

@end
