//
//  NAVURLElement.m
//  Navigator
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

# pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[self.class alloc] initWithKey:self.key data:self.data index:self.index];
}

- (BOOL)isEqual:(NAVURLComponent *)object
{
    return [object isKindOfClass:[NAVURLComponent class]]
        && [object.key isEqualToString:self.key]
        && [object.data ?: @"" isEqualToString:self.data ?: @""];
}

- (NSUInteger)hash
{
    return [self.key hash] + [self.data hash];
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

- (NSString *)data
{
    return nil;
}

# pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[self.class alloc] initWithKey:self.key options:self.options];
}

- (BOOL)isEqual:(NAVURLParameter *)object
{
    return [object isKindOfClass:[NAVURLParameter class]]
        && [object.key isEqualToString:self.key]
        && object.options == self.options;
}

- (NSUInteger)hash
{
    return [self.key hash] + self.options;
}

# pragma mark - Accessors

- (BOOL)isVisible
{
    return (self.options & NAVParameterOptionsVisible) == NAVParameterOptionsVisible;
}

- (BOOL)isAnimated
{
    return (self.options & NAVParameterOptionsUnanimated) == 0;
}

- (BOOL)isAsynchronous
{
    return (self.options & NAVParameterOptionsAsync) == NAVParameterOptionsAsync;
}

- (NSString *)value
{
    // if we're not visible render nothing
    if(!self.isVisible) {
        return nil;
    }
    
    NSMutableString *result = [NSMutableString new];
    
    // for each option in the option set, get the string value
    for(NAVParameterOptions option=1 ; option ; option<<=1) {
        // check to see this is part of our options
        if(!(option & self.options)) {
            continue;
        }
       
        // if this option has no mapped substring, then we're done
        NSString *substring = nav_parameterOptionToString(option);
        if(!substring) {
            break;
        }
        
        // accumulate the string
        [result appendString:substring];
    }
    
    return [result copy];
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
