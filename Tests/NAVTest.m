//
//  NAVTest.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVTest.h"

@implementation NAVTest

+ (NSString *)scheme
{
    return @"test";
}

+ (NAVURL *(^)(NSString *))URL
{
    return ^(NSString *path) {
        return [NAVURL URLWithURL:[NSURL URLWithString:path] resolvingAgainstScheme:self.scheme];
    };
}

@end

@implementation NSURL (Test)

+ (instancetype)URLWithFormat:(NSString *)format, ...
{
    va_list arguments;
    va_start(arguments, format);
    NSURL *url = [self URLWithString:[[NSString alloc] initWithFormat:format arguments:arguments]];
    va_end(arguments);
    return url;
}

@end
