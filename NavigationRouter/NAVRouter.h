//
//  NAVRouter.h
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRouterDelegate.h"
#import "NAVRouterParser.h"
#import "NAVRouterUpdater.h"
#import "NAVRouterFactory.h"
#import "NAVRouteBuilder.h"
#import "NAVAttributesBuilder.h"

#define NAVRouterLogLevel 1

@interface NAVRouter : NSObject

@property (weak  , nonatomic) id<NAVRouterDelegate> delegate;
@property (strong, nonatomic) id<NAVRouterUpdater> updater;
@property (strong, nonatomic) id<NAVRouterParser> parser;
@property (strong, nonatomic) id<NAVRouterFactory> factory;

@property (copy  , nonatomic, readonly) NSString *scheme;
@property (copy  , nonatomic, readonly) NSURL *currentURL;
@property (assign, nonatomic, readonly) BOOL isTransitioning;

@property (strong, nonatomic) Class attributesClass;
@property (strong, nonatomic) Class routeClass;

- (instancetype)initWithScheme:(NSString *)scheme;
- (void)updateRoutes:(void(^)(NAVRouteBuilder *route))routingBlock;
- (void)transitionWithAttributes:(NAVAttributes *)attributes animated:(BOOL)isAnimated completion:(void(^)(void))completion;
- (NAVAttributesBuilder *)attributesBuilder;

@end
