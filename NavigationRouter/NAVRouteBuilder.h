//
//  NAVRouteBuilder.h
//  Created by Ty Cobb on 3/25/14.
//

#import "NAVRoute.h"

@interface NAVRouteBuilder : NSObject

@property (nonatomic, readonly) NSMutableDictionary *routes;

- (instancetype)initWithRoutes:(NSDictionary *)routes;

- (NAVRoute *(^)(NSString *component))to;
- (void(^)(NSString *component))remove;

@end

@interface NAVRoute (Builder)
- (NAVRoute *(^)(NAVRouteType type))as;
@end
