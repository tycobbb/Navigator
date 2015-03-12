//
//  NAVRouter.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRoute.h"

@implementation NAVRoute

- (id)copyWithZone:(NSZone *)zone
{
    NAVRoute *copy = [NAVRoute new];
   
    copy.type = self.type;
    copy.path = self.path;
    copy.destination = self.destination;
    
    return copy;
}

@end

BOOL NAVRouteTypeIsAnimator(NAVRouteType type) {
    return type == NAVRouteTypeAnimation;
}
