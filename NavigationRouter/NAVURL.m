//
//  NAVURL.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURL.h"

@implementation NAVURL

+ (instancetype)URLWithURL:(NSURL *)systemURL resolvingAgainstScheme:(NSString *)scheme
{
    return [[self alloc] initWithURL:systemURL resolvingAgainstscheme:scheme];
}

- (instancetype)initWithURL:(NSURL *)url resolvingAgainstscheme:(NSString *)scheme
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
    
    _nav_host = self.host ? [[NAVURLComponent alloc] initWithKey:self.host index:0] : nil;
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
        return [[NAVURLComponent alloc] initWithKey:component index:index - 1];
    }).skip(1);
}

- (NSDictionary *)parseParamatersFromQuery:(NSString *)query
{
    if(!query.length)
        return @{ };
    
    // TODO: this is unsafe if there is no the component is nil (ie. parameter is "=")
    return query.split(@"&").map(^(NSString *parameter) {
        NSMutableArray *pair = [parameter.split(@"=") mutableCopy];
        pair[1] = [[NAVURLParameter alloc] initWithKey:pair[0] options:pair[1]];
        return pair;
    }).dict;
}

# pragma mark - Accessors

- (NAVURLComponent *)nav_componentAtIndex:(NSInteger)index
{
    return self.nav_components[index];
}

- (NAVURLParameter *)nav_parameterForKey:(NSString *)key
{
    return self.nav_parameters[key];
}

- (NAVURLComponent *)objectAtIndexedSubscript:(NSInteger)index
{
    return [self nav_componentAtIndex:index];
}

- (NAVURLParameter *)objectForKeyedSubscript:(NSString *)key
{
    return [self nav_parameterForKey:key];
}

@end
