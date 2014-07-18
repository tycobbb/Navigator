//
//  NAVParameter.m
//  Created by Ty Cobb on 7/17/14.
//

#import "NAVURLParameter.h"

@implementation NAVURLParameter

- (instancetype)initWithComponent:(NSString *)component options:(NSNumber *)optionsValue
{
    if(self = [super init])
    {
        _component = component;
        _options   = [optionsValue integerValue];
    }
    
    return self;
}

- (BOOL)isVisible
{
    return self.options & NAVParameterOptionsVisible;
}

@end
