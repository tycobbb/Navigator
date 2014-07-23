//
//  NAVRouter.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRoute.h"

@implementation NAVRoute

- (id)copyWithZone:(NSZone *)zone
{
    NAVRoute *copy = [NAVRoute new];
    copy.type      = self.type;
    copy.path = self.path;
    return copy;
}

@end
