//
//  NAVAnimationModal.m
//  NavigationRouter
//

#import "NAVAnimationModal.h"
#import "NAVRouterUtilities.h"
#import "NAVRouterConstants.h"

@interface NAVAnimationModal ()
@property (copy, nonatomic) NAVRoute *route;
@end

@implementation NAVAnimationModal

- (instancetype)init
{
    return [self initWithRoute:nil];
}

- (instancetype)initWithRoute:(NAVRoute *)route
{
    NAVAssert(route.type == NAVRouteTypeModal, NAVExceptionInvalidRoute, @"Cannot create a modal animator without a modal route.");
    
    if(self = [super init]) {
        _route = route;
    }
    
    return self;
}

@end
