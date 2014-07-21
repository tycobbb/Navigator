//
//  NAVUpdateBuilder.h
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVUpdate.h"
#import "NAVURLComponent.h"
#import "NAVURLParameter.h"
#import "NAVRouterFactory.h"

@protocol NAVUpdateBuilderDelegate;

@interface NAVUpdateBuilder : NSObject

@property (weak, nonatomic) id<NAVUpdateBuilderDelegate> delegate;

- (NAVUpdate *)build;

- (NAVUpdateBuilder *(^)(NAVUpdateType))as;
- (NAVUpdateBuilder *(^)(NAVURLComponent *))component;
- (NAVUpdateBuilder *(^)(NAVURLParameter *))parameter;

- (NAVUpdateBuilder *)with;
- (NAVUpdateBuilder *)and;

@end

@protocol NAVUpdateBuilderDelegate <NSObject>
- (NAVRoute *)builder:(NAVUpdateBuilder *)builder routeForKey:(NSString *)key;
- (id<NAVRouterFactory>)factoryForBuilder:(NAVUpdateBuilder *)builder;
@end
