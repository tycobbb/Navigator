//
//  NAVUpdate.m
//  Created by Ty Cobb on 7/17/14.
//

#import "NAVUpdate.h"

@implementation NAVUpdate

+ (instancetype)updateWithType:(NAVUpdateType)type route:(NAVRoute *)route
{
    return [[self alloc] initWithType:type route:route];
}

- (instancetype)initWithType:(NAVUpdateType)type route:(NAVRoute *)route
{
    if(self = [super init])
    {
        _type  = type;
        _route = route;
    }
    
    return self;
}

- (void)performWithUpdater:(id<NAVRouterUpdater>)updater completion:(void (^)(BOOL))completion { };

@end
