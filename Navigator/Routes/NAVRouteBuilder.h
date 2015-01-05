//
//  NAVRouteBuilder.h
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRoute.h"
#import "NAVAnimation.h"

@interface NAVRouteBuilder : NSObject

@property (nonatomic, readonly) NSMutableDictionary *routes;
@property (nonatomic, readonly) NSMutableArray *addedRoutes;
@property (nonatomic, readonly) NSMutableArray *removedRoutes;

- (instancetype)initWithRoutes:(NSDictionary *)routes;

- (NAVRoute *(^)(NSString *component))to;
- (void(^)(NSString *component))remove;

@end

@interface NAVRoute (Builder)

- (NAVRoute *(^)(NAVRouteType))as;
- (NAVRoute *(^)(Class))controller;
- (NAVRoute *(^)(NAVAnimation *))animation;

- (NAVRoute *)with;

@end
