//
//  NSError+NAVRouter.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NSError+NAVRouter.h"

NSString * const NAVRouterErrorDomain = @"navrouter.error";

@implementation NSError (NAVRouter)

+ (NSError *)nav_errorWithDescription:(NSString *)description
{
    return [NSError errorWithDomain:NAVRouterErrorDomain code:-1 userInfo:@{
        NSLocalizedDescriptionKey : description ?: @"Unknown error.",
    }];
}

@end
