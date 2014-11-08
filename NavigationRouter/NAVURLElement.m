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

- (instancetype)initWithKey:(NSString *)key options:(NAVParameterOptions)options
{
    if(self = [super initWithKey:key]) {
        _options = options;
    }
    
    return self;
}

- (BOOL)isVisible
{
    return (self.options & NAVParameterOptionsVisible) == NAVParameterOptionsVisible;
}

- (NSString *)value
{
    // if we're not visible just show nothing
    if(!self.isVisible) {
        return nil;
    }
    
    // start with the visible string
    NSMutableString *value = [NSMutableString new];
    
    // for each option in the option set, get the string value
    for(NAVParameterOptions option=1 ; option ; option <<= 1) {
        NSString *optionValue = nav_parameterOptionToString(option);
        // if we have no option value, then let's set option to .Hidden to poison the loop
        if(!optionValue) {
            option = NAVParameterOptionsHidden;
        }
        // accumulate the value
        [value appendString:optionValue];
    }
    
    return [value copy];
}

NSString * nav_parameterOptionToString(NAVParameterOptions option)
{
    switch(option) {
        case NAVParameterOptionsVisible:
            return @"v";
        case NAVParameterOptionsAsync:
            return @"a";
        case NAVParameterOptionsUnanimated:
            return @"u";
        default:
            return nil;
    }
}

@end
