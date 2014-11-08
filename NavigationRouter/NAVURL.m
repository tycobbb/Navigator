//
//  NAVURL.m
//  NavigationRouter
//

#import <YOLOKit/YOLO.h>
#import "NAVURL.h"

@implementation NAVURL

+ (instancetype)URLWithPath:(NSString *)path
{
    if(!path)
        return nil;
    return [[self alloc] initWithPath:path];
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
    if(majorSubdivisions.count != 2) {
        [NSException raise:@"rocket.no.scheme.error" format:@"No scheme found for path: %@", path];
    }
    
    NSString *scheme       = majorSubdivisions[0];
    NSString *relativePath = majorSubdivisions[1];
    
    // subdivide the path into components & parameters
    NSArray *minorSubdivisions = relativePath.split(@"?");
    
    // validate that we don't have too many minor subdivisions
    if(majorSubdivisions.count > 2) {
        [NSException raise:@"rocket.too.many.queries" format:@"Only one query string is allowed for path: %@", path];
    }

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
    
    return path.split(@"/").map(^(NSString *subpath, NSInteger index) {
        // seperate subpath based on data delimiter
        NSArray *components = subpath.split(@"::");
        // validate that we don't have too many data strings
        if(components.count > 2) {
            [NSException raise:@"rocket.too.many.data.strings" format:@"Only one data string is allowed for subpath: %@", subpath];
        }
        
        NSString *dataString = components.count > 1 ? components[1] : nil;
        
        return [[NAVURLComponent alloc] initWithKey:components.firstObject data:dataString index:index];
    });
}

+ (NSArray *)parametersFromQuery:(NSString *)query
{
    if(!query.length) {
        return @[];
    }
    
    // map elements seperated by parameter delimiter
    return query.split(@"&").map(^(NSString *parameter) {
        // seperate components based on key-value delimiter
        NSArray *pair = parameter.split(@"=");
        // validate that we have the right number of elements
        if(pair.count != 2) {
            [NSException raise:@"rocket.invalid.parameter" format:@"Parameter must have key and value: %@", parameter];
        }
        
        return [[NAVURLParameter alloc] initWithKey:pair[0] options:[pair[1] integerValue]];
    });
}

# pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[NAVURL alloc] initWithUrl:self];    
}

@end
