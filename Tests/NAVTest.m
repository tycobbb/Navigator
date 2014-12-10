//
//  NAVTest.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVTest.h"

@implementation NAVTest

+ (NSString *)scheme
{
    return @"navigator";
}

+ (NAVURL *)url:(NSString *)path
{
    return [[NAVURL alloc] initWithPath:[NSString stringWithFormat:@"%@://%@", self.scheme, path ?: @""]];
}

@end

NAVURL * URL(NSString *path) {
    return [NAVTest url:path];
}

NSArray * URLs(NSArray *paths) {
    return paths.map(^(NSString *path) {
        return [NAVTest url:path];
    });
}
