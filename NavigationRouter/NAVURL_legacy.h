//
//  NAVURL.h
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURLComponent_legacy.h"
#import "NAVURLParameter_legacy.h"

typedef NS_ENUM(SInt32, NAVURLType) {
    NAVURLTypeInternal,
    NAVURLTypeExternal
};

@interface NAVURL_legacy : NSURL

@property (assign, nonatomic, readonly) NAVURLType type;
@property (strong, nonatomic, readonly) NAVURLComponent_legacy *nav_host;
@property (strong, nonatomic, readonly) NSArray *nav_components;
@property (strong, nonatomic, readonly) NSDictionary *nav_parameters;

+ (instancetype)URLWithURL:(NSURL *)url resolvingAgainstScheme:(NSString *)scheme;
- (instancetype)initWithURL:(NSURL *)url resolvingAgainstScheme:(NSString *)scheme;

- (NAVURLComponent_legacy *)nav_componentAtIndex:(NSInteger)index;
- (NAVURLParameter_legacy *)nav_parameterForKey:(NSString *)key;

- (NAVURLComponent_legacy *)objectAtIndexedSubscript:(NSInteger)index;
- (NAVURLParameter_legacy *)objectForKeyedSubscript:(NSString *)key;

@end

@interface NSURL (NAVURL)
- (NAVURL_legacy *)nav_url;
@end
