//
//  NAVAttributesBuilder.h
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVAttributes_legacy.h"
#import "NAVURLParameter_legacy.h"

@interface NAVAttributesBuilder_legacy : NSObject

- (instancetype)initWithSourceURL:(NSURL *)sourceURL;
- (NAVAttributes_legacy *)build;

- (NAVAttributesBuilder_legacy *)toPath:(NSString *)path;
- (NAVAttributesBuilder_legacy *)popBack:(NSInteger)popCount;
- (NAVAttributesBuilder_legacy *)withParameter:(NSString *)parameter options:(NAVParameterOptions_legacy)options;
- (NAVAttributesBuilder_legacy *)withModel:(id)model;

- (NAVAttributesBuilder_legacy *(^)(NSString *))to;
- (NAVAttributesBuilder_legacy *(^)(id model))model;
- (NAVAttributesBuilder_legacy *(^)(NSInteger))pop;
- (NAVAttributesBuilder_legacy *(^)(NSString *, NAVParameterOptions_legacy))parameter;

- (NAVAttributesBuilder_legacy *)with;

@end
