//
//  NAVURL.h
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURLComponent.h"
#import "NAVURLParameter.h"

typedef NS_ENUM(SInt32, NAVURLType) {
    NAVURLTypeInternal,
    NAVURLTypeExternal
};

@interface NAVURL : NSURL

@property (assign, nonatomic, readonly) NAVURLType type;
@property (strong, nonatomic, readonly) NAVURLComponent *nav_host;
@property (strong, nonatomic, readonly) NSArray *nav_components;
@property (strong, nonatomic, readonly) NSDictionary *nav_parameters;

+ (instancetype)URLWithURL:(NSURL *)url resolvingAgainstScheme:(NSString *)scheme;
- (instancetype)initWithURL:(NSURL *)url resolvingAgainstscheme:(NSString *)scheme;

- (NAVURLComponent *)nav_componentAtIndex:(NSInteger)index;
- (NAVURLParameter *)nav_parameterForKey:(NSString *)key;

- (NAVURLComponent *)objectAtIndexedSubscript:(NSInteger)index;
- (NAVURLParameter *)objectForKeyedSubscript:(NSString *)key;

@end
