//
//  NAVRouteTransformer.h
//  Created by Ty Cobb on 3/25/14.
//

@interface NAVRouteTransformer : NSValueTransformer
+ (instancetype)sharedInstance;
+ (void)updateRoutes:(NSDictionary *)routes;
@end
