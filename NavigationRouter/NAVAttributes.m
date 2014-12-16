//
//  NAVAttributes.m
//  NavigationRouter
//

#import "NAVAttributes.h"

@implementation NAVAttributes

@end

@implementation NAVAttributes (Builder)

+ (NAVTransitionBuilder *)builder
{
    return [NAVTransitionBuilder new];
}

@end
