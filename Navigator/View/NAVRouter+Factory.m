//
//  NAVRouter+Factory.m
//  Navigator
//

#import "NAVRouter+Factory.h"
#import "NAVViewControllerFactory.h"

@implementation NAVRouter (Factory)

- (id<NAVRouterFactory>)defaultFactory
{
    return [NAVViewControllerFactory new];
}

@end
