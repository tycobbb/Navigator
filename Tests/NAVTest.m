//
//  NAVTest.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVTest.h"

@implementation NAVTest

+ (NSString *)scheme
{
    return @"rocket";
}

+ (NAVURL *)url
{
    return URL([NSString stringWithFormat:@"%@://test", self.scheme]);
}

@end

NAVURL * URL(NSString *path) {
    return [[NAVURL alloc] initWithPath:path];
}

NSArray * URLs(NSArray *paths) {
    return paths.map(^(NSString *path) {
        return [[NAVURL alloc] initWithPath:path];
    });
}
