//
//  NAVURL.m
//  Created by Ty Cobb on 7/18/14.
//

#import "YOLOKit/YOLO.h"
#import "YOLT.h"

#import "NAVURL_legacy.h"
#import "NSURL+NAVRouter.h"

@implementation NAVURL_legacy

+ (instancetype)URLWithURL:(NSURL *)systemURL resolvingAgainstScheme:(NSString *)scheme
{
    return [[self alloc] initWithURL:systemURL resolvingAgainstScheme:scheme];
}

- (instancetype)initWithURL:(NSURL *)url resolvingAgainstScheme:(NSString *)scheme
{
    if(self = [super initWithString:url.absoluteString])
        [self parseAgainstScheme:scheme];
    return self;
}

# pragma mark - Parsing

- (void)parseAgainstScheme:(NSString *)scheme
{
    _type = [self.scheme isEqualToString:scheme] ? NAVURLTypeInternal : NAVURLTypeExternal;
    
    if(_type != NAVURLTypeInternal)
        return;
    
    _nav_host = self.host ? [[NAVURLComponent_legacy alloc] initWithKey:self.host index:0] : nil;
    _nav_components = [self parseComponentsFromPath:self.path];
    _nav_parameters = [self parseParamatersFromQuery:self.query];
}

//
// Helpers
//

- (NSArray *)parseComponentsFromPath:(NSString *)path
{
    // the path always begins with a '/', so this guards against that case as well as the nil
    // and 0-length cases
    if(path.length < 2)
        return @[ ];
    
    return path.split(@"/").map(^(NSString *component, NSInteger index) {
        return [[NAVURLComponent_legacy alloc] initWithKey:component index:index - 1];
    }).skip(1);
}

- (NSDictionary *)parseParamatersFromQuery:(NSString *)query
{
    NSDictionary *parameters = [NSURL nav_parameterDictionaryFromQuery:query];
    return parameters.nav_map(^(NSString *key, NSNumber *options) {
        return [[NAVURLParameter_legacy alloc] initWithKey:key options:options];
    });
}

# pragma mark - Accessors

- (NAVURLComponent_legacy *)nav_componentAtIndex:(NSInteger)index
{
    return self.nav_components[index];
}

- (NAVURLParameter_legacy *)nav_parameterForKey:(NSString *)key
{
    return self.nav_parameters[key];
}

- (NAVURLComponent_legacy *)objectAtIndexedSubscript:(NSInteger)index
{
    return [self nav_componentAtIndex:index];
}

- (NAVURLParameter_legacy *)objectForKeyedSubscript:(NSString *)key
{
    return [self nav_parameterForKey:key];
}

@end

@implementation NSURL (NAVURL)

- (NAVURL_legacy *)nav_url
{
    return [NAVURL_legacy URLWithURL:self resolvingAgainstScheme:self.scheme];
}

@end
