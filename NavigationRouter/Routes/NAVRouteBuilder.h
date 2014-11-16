//
//  NAVRouteBuilder.h
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRoute.h"

@interface NAVRouteBuilder : NSObject

@property (nonatomic, readonly) NSMutableDictionary *routes;

- (instancetype)initWithRoutes:(NSDictionary *)routes;

- (NAVRoute *)toPath:(NSString *)path;
- (void)removeMatchingPath:(NSString *)path;

- (NAVRoute *(^)(NSString *component))to;
- (void(^)(NSString *component))remove;

@end

@interface NAVRoute (Builder)

- (NAVRoute *)asType:(NAVRouteType)type;
- (NAVRoute *)withControllerClass:(Class)klass;

- (NAVRoute *(^)(NAVRouteType))as;
- (NAVRoute *(^)(Class))controller;

- (NAVRoute *)with;

@end
