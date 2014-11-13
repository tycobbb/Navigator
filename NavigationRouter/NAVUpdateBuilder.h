//
//  NAVUpdateBuilder.h
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVUpdate.h"
#import "NAVUpdateAnimation.h"

#import "NAVURLComponent_legacy.h"
#import "NAVURLParameter_legacy.h"
#import "NAVAttributes_legacy.h"
#import "NAVRouterFactory.h"

@protocol NAVUpdateBuilderDelegate;

@interface NAVUpdateBuilder : NSObject

@property (weak, nonatomic) id<NAVUpdateBuilderDelegate> delegate;

- (NAVUpdate *)build;

- (NAVUpdateBuilder *)asType:(NAVUpdateType)type;
- (NAVUpdateBuilder *)withAttributes:(NAVAttributes_legacy *)attributes;
- (NAVUpdateBuilder *)withComponent:(NAVURLComponent_legacy *)component;
- (NAVUpdateBuilder *)withParameter:(NAVURLParameter_legacy *)parameter;

- (NAVUpdateBuilder *(^)(NAVUpdateType))as;
- (NAVUpdateBuilder *(^)(NAVAttributes_legacy *))attributes;
- (NAVUpdateBuilder *(^)(NAVURLComponent_legacy *))component;
- (NAVUpdateBuilder *(^)(NAVURLParameter_legacy *))parameter;

- (NAVUpdateBuilder *)with;
- (NAVUpdateBuilder *)and;

@end

@protocol NAVUpdateBuilderDelegate <NSObject>
- (NAVRoute *)builder:(NAVUpdateBuilder *)builder routeForKey:(NSString *)key;
- (UIViewController *)builder:(NAVUpdateBuilder *)builder controllerForUpdate:(NAVUpdate *)update;
- (NAVAnimator *)builder:(NAVUpdateBuilder *)builder animatorForUpdate:(NAVUpdateAnimation *)update;
@end
