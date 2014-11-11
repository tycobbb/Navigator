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

@end

NAVURL * URL(NSString *path) {
    return [[NAVURL alloc] initWithPath:path];
}

NSArray * URLs(NSArray *paths) {
    return paths.map(^(NSString *path) {
        return [[NAVURL alloc] initWithPath:path];
    });
}
