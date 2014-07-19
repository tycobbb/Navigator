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
