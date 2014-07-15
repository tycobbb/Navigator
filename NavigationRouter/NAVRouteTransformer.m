//
//  NAVRouteTransformer.m
//  Created by Ty Cobb on 3/25/14.
//

#import "NAVRouteTransformer.h"
#import "NAVRoute.h"

#define NAVRouteTransformerName @"NAVMainRouteTransformer"

@interface NAVRouteTransformer ()
@property (strong, nonatomic) NSMutableDictionary *routes;
@end

@implementation NAVRouteTransformer

- (id)init
{
    if(self = [super init])
        _routes = [NSMutableDictionary new];
    return self;
}

+ (instancetype)sharedInstance
{
    return (NAVRouteTransformer *)[NSValueTransformer valueTransformerForName:@"NAVRouteTransformer"];
}

+ (void)updateRoutes:(NSDictionary *)routes
{
    [[NAVRouteTransformer sharedInstance].routes setValuesForKeysWithDictionary:routes];
}

- (id)transformedValue:(id)value
{
    return self.routes[value];
}

- (id)reverseTransformedValue:(NAVRoute *)route
{
    return route.component;
}

@end
