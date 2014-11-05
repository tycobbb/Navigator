//
//  NAVParameter.m
//  Created by Ty Cobb on 7/17/14.
//

#import "NAVURLParameter_legacy.h"

@implementation NAVURLParameter_legacy

- (instancetype)initWithKey:(NSString *)key options:(NSNumber *)optionsValue
{
    if(self = [super initWithKey:key])
        _options = [optionsValue integerValue];
    return self;
}

- (BOOL)isVisible
{
    return self.options & NAVParameterOptions_legacyVisible;
}

# pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    NAVURLParameter_legacy *copy = [super copyWithZone:zone];
    copy.options = self.options;
    return self;
}

# pragma mark - Description

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@" %@: %@", self.key, [self stringFromOptions:self.options]];
}

- (NSString *)stringFromOptions:(NAVParameterOptions_legacy)options
{
    NSMutableString *optionString = [NSMutableString new];
    if(options & NAVParameterOptions_legacyHidden)
        [optionString appendString:@"h"];
    if(options & NAVParameterOptions_legacyVisible)
        [optionString appendString:@"v"];
    if(options & NAVParameterOptions_legacyUnanimated)
        [optionString appendString:@"u"];
    return [optionString copy];
}

@end
