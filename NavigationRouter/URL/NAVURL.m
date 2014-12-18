//
//  NAVURL.m
//  NavigationRouter
//

#import <YOLOKit/YOLO.h>
#import "NAVURL.h"
#import "NAVRouterUtilities.h"
#import "YOLT.h"

NSString * const NAVExceptionMalformedUrl = @"router.malformed.url";
NSString * const NAVExceptionIllegalUrlMutation = @"router.illegal.url.mutation";

@interface NAVURL ()
@property (copy, nonatomic) NSString *scheme;
@property (copy, nonatomic) NSArray *components;
@property (copy, nonatomic) NSDictionary *parameters;
@end

@implementation NAVURL

+ (instancetype)URLWithPath:(NSString *)path
{
    if(!path) {
        return nil;
    }
    
    return [[self alloc] initWithPath:path];
}

- (instancetype)init
{
    return [self initWithPath:nil];
}

- (instancetype)initWithPath:(NSString *)path
{
    NSParameterAssert(path);
    
    NSArray *subdivisions = [self.class subdividePath:path];
    
    // initialize the URL from these components
    if(self = [super init]) {
        _scheme     = subdivisions[0];
        _components = [self.class componentsFromPath:subdivisions[1]];
        _parameters = [self.class parametersFromQuery:subdivisions[2]];
    }
    
    return self;
}

- (instancetype)initWithUrl:(NAVURL *)url
{
    NSParameterAssert(url);
    
    if(self = [super init]) {
        _scheme     = url.scheme;
        _components = url.components;
        _parameters = url.parameters;
    }
    
    return self;
}

# pragma mark - Parsing

+ (NSArray *)subdividePath:(NSString *)path
{
    // split path on scheme delimiter
    NSArray *majorSubdivisions = path.split(@"://");
    
    // validate that we have the correct number of components
    NAVAssert(majorSubdivisions.count == 2, NAVExceptionMalformedUrl, @"No scheme found for path: %@", path);
    
    NSString *scheme       = majorSubdivisions[0];
    NSString *relativePath = majorSubdivisions[1];
    
    // subdivide the path into components & parameters
    NSArray *minorSubdivisions = relativePath.split(@"?");
    
    // validate that we don't have too many minor subdivisions
    NAVAssert(minorSubdivisions.count <= 2, NAVExceptionMalformedUrl, @"Only one query string is allowed for path: %@", path);

    return @[
        scheme,
        minorSubdivisions[0], // components
        minorSubdivisions.count > 1 ? minorSubdivisions[1] : @"" // parameters
    ];
}

+ (NSArray *)componentsFromPath:(NSString *)path
{
    if(!path.length) {
        return @[];
    }
    
    // map subpaths into NAVURLComponents
    return path.split(@"/").map(^(NSString *subpath, NSInteger index) {
        return [self componentFromString:subpath index:index];
    });
}

+ (NSDictionary *)parametersFromQuery:(NSString *)query
{
    if(!query.length) {
        return @{};
    }
    
    // map parameter strings into NAVURLParameters
    return query.split(@"&").map(^(NSString *string) {
        NAVURLParameter *parameter = [self parameterFromString:string];
        return @[ parameter.key, parameter ];
    }).dict;
}

# pragma mark - Component Generation

+ (NAVURLComponent *)componentFromString:(NSString *)string index:(NSInteger)index
{
    // if there's no string here, we're not going to treat this as a component. probably
    // a trailing slash
    if(!string.length) {
        return nil;
    }
    
    // seperate subpath based on data delimiter
    NSArray *components = string.split(@"::");
    
    // validate that we don't have too many data strings
    NAVAssert(components.count <= 2, NAVExceptionMalformedUrl, @"Only one data string is allowed for subpath: %@", string);
    NSString *dataString = components.count > 1 ? components[1] : nil;

    return [[NAVURLComponent alloc] initWithKey:components.firstObject data:dataString index:index];
}

+ (NAVURLParameter *)parameterFromString:(NSString *)string
{
    // seperate components based on key-value delimiter
    NSArray *pair = string.split(@"=");
    
    // validate that we have the right number of elements
    NAVAssert(pair.count == 2, NAVExceptionMalformedUrl, @"Parameter must have key and value: %@", string);
    
    return [[NAVURLParameter alloc] initWithKey:pair[0] options:[pair[1] integerValue]];
}

# pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[NAVURL alloc] initWithUrl:self];    
}

- (BOOL)isEqual:(id)object
{
    return [self.string isEqual:self.string];
}

- (NSUInteger)hash
{
    return [self.string hash];
}

# pragma mark - Debugging

- (NSString *)debugDescription
{
    return [[super debugDescription] stringByAppendingFormat:@"path: %@", self.string];
}

@end

@implementation NAVURL (Subscripting)

- (NAVURLComponent *)lastComponent
{
    return self.components.count ? self.components[self.components.count-1] : nil;
}

- (NAVURLComponent *)objectAtIndexedSubscript:(NSInteger)index
{
    return index < self.components.count ? self.components[index] : nil;
}

- (NAVURLParameter *)objectForKeyedSubscript:(NSString *)key
{
    return self.parameters[key];
}

@end

@implementation NAVURL (Operators)

- (NAVURL *)push:(NSString *)subpath
{
    NAVAssert(subpath != nil, NAVExceptionIllegalUrlMutation, @"%@; cannot push a nil subpath", self);

    NAVURL *result = [self copy];
    
    // create component from subpath (if possible)
    NAVURLComponent *component = [self.class componentFromString:subpath index:result.components.count];
    result.components = result.components.nav_append(component);
    
    return result;
}

- (NAVURL *)setData:(NSString *)data
{
    NAVURL *result = [self copy];
    NAVURLComponent *lastComponent = self.lastComponent;
    
    if(lastComponent) {
        // replace the last component with a copy with the updated data, if there is one
        NAVURLComponent *replacement = [[NAVURLComponent alloc] initWithKey:lastComponent.key data:data index:lastComponent.index];
        result.components = result.components.nav_replace(replacement.index, replacement);
    }
    
    return result;
}

- (NAVURL *)pop:(NSUInteger)count
{
    NAVAssert(count <= self.components.count, NAVExceptionIllegalUrlMutation, @"%@ doesn't have %d components to pop", self, (int)count);
    
    NAVURL *result = [self copy];
    result.components = result.components.snip(count);
    
    return result;
}

- (NAVURL *)updateParameter:(NSString *)key withOptions:(NAVParameterOptions)options
{
    NAVAssert(key != nil, NAVExceptionIllegalUrlMutation, @"%@ can't update a parameter with a nil name", self);
    
    NAVURL *result = [self copy];

    // set a new NAVURLParameter from the key and options
    NAVURLParameter *parameter = [[NAVURLParameter alloc] initWithKey:key options:options];
    result.parameters = result.parameters.nav_set(key, parameter);
    
    return result;
}

@end

@implementation NAVURL (Serialization)

- (NSString *)string
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@://", self.scheme];
    
    // append components joined by by "/"
    NSString *path = self.components.map(^(NAVURLComponent *component) {
        return component.data ? [component.key stringByAppendingFormat:@"::%@", component.data] : component.key;
    }).join(@"/");
    
    [string appendString:path];
    
    // join visible parameters by "&"
    NSString *query = self.parameters.map(^(NSString *key, NAVURLParameter *parameter) {
        return parameter.isVisible ? [NSString stringWithFormat:@"%@=%@", parameter.key, parameter.value] : nil;
    }).join(@"&");
   
    // append query if it there's anything to append
    if(query.length) {
        [string appendFormat:@"?%@", query];
    }
    
    return [string copy];
}

- (NSURL *)url
{
    return [[NSURL alloc] initWithString:self.string];
}

@end
