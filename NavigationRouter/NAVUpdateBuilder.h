//
//  NAVUpdateBuilder.h
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVUpdate.h"
#import "NAVUpdateAnimation.h"

#import "NAVURLComponent.h"
#import "NAVURLParameter.h"
#import "NAVAttributes.h"
#import "NAVRouterFactory.h"

@protocol NAVUpdateBuilderDelegate;

@interface NAVUpdateBuilder : NSObject

@property (weak, nonatomic) id<NAVUpdateBuilderDelegate> delegate;

- (NAVUpdate *)build;

- (NAVUpdateBuilder *)asType:(NAVUpdateType)type;
- (NAVUpdateBuilder *)withAttributes:(NAVAttributes *)attributes;
- (NAVUpdateBuilder *)withComponent:(NAVURLComponent *)component;
- (NAVUpdateBuilder *)withParameter:(NAVURLParameter *)parameter;

- (NAVUpdateBuilder *(^)(NAVUpdateType))as;
- (NAVUpdateBuilder *(^)(NAVAttributes *))attributes;
- (NAVUpdateBuilder *(^)(NAVURLComponent *))component;
- (NAVUpdateBuilder *(^)(NAVURLParameter *))parameter;

- (NAVUpdateBuilder *)with;
- (NAVUpdateBuilder *)and;

@end

@protocol NAVUpdateBuilderDelegate <NSObject>
- (NAVRoute *)builder:(NAVUpdateBuilder *)builder routeForKey:(NSString *)key;
- (UIViewController *)builder:(NAVUpdateBuilder *)builder controllerForUpdate:(NAVUpdate *)update;
- (NAVAnimator *)builder:(NAVUpdateBuilder *)builder animatorForUpdate:(NAVUpdateAnimation *)update;
@end
