//
//  NAVAttributesBuilder.h
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVAttributes.h"
#import "NAVURLParameter.h"

@interface NAVAttributesBuilder : NSObject

- (instancetype)initWithSourceURL:(NSURL *)sourceURL;
- (NAVAttributes *)build;

- (NAVAttributesBuilder *)toPath:(NSString *)path;
- (NAVAttributesBuilder *)popBack:(NSInteger)popCount;
- (NAVAttributesBuilder *)withParameter:(NSString *)parameter options:(NAVParameterOptions)options;
- (NAVAttributesBuilder *)withModel:(id)model;

- (NAVAttributesBuilder *(^)(NSString *))to;
- (NAVAttributesBuilder *(^)(id model))model;
- (NAVAttributesBuilder *(^)(NSInteger))pop;
- (NAVAttributesBuilder *(^)(NSString *, NAVParameterOptions))parameter;

- (NAVAttributesBuilder *)with;

@end
