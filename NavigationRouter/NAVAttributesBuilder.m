//
//  NAVAttributesBuilder.m
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVRouterImports.h"
#import "NAVAttributesBuilder.h"
#import "NSURL+NAVRouter.h"

@interface NAVAttributesBuilder ()
@property (strong, nonatomic) NSURL *attributesSourceURL;
@property (strong, nonatomic) NSString *attributesPath;
@property (strong, nonatomic) NSMutableDictionary *attributesParameters;
@property (strong, nonatomic) id attributesModel;
@property (assign, nonatomic) NSInteger popCount;
@end

@implementation NAVAttributesBuilder

- (instancetype)initWithSourceURL:(NSURL *)sourceURL
{
    if(self = [super init])
        _attributesSourceURL = sourceURL;
    return self;
}

- (NAVAttributes *)build
{
    NAVAttributes *attributes = [NAVAttributes new];
    attributes.model          = [self attributesModel];
    attributes.sourceURL      = [self attributesSourceURL];
    attributes.destinationURL = [self constructDestinationURL];
    return attributes;
}

//
// Helpers
//

- (NSURL *)constructDestinationURL
{
    // if the URL is absolute, we're going to short-circuit the construction process
    BOOL isAbsolute = [self.attributesPath hasPrefix:[NSString stringWithFormat:@"%@://", self.attributesSourceURL.scheme]];
    if(isAbsolute)
        return [NSURL URLWithString:self.attributesPath];

    NSURLComponents *components = [NSURLComponents componentsWithURL:self.attributesSourceURL resolvingAgainstBaseURL:YES];
    if(self.attributesPath)
        [self components:components resolveRelativePath:self.attributesPath];
    else if(self.popCount)
        [self components:components popPathComponentsWithCount:self.popCount];
    else if(self.attributesParameters)
        [self components:components updateParameters:self.attributesParameters];
    return [components URL];
}

- (void)components:(NSURLComponents *)components resolveRelativePath:(NSString *)path
{
    NSArray *relativeComponents = [self componentsFromPath:path];
    
    // if there's no host, we'll treat the first component as such and use the rest as a relative path
    if(!components.host)
    {
        components.host    = relativeComponents.firstObject;
        relativeComponents = relativeComponents.skip(1);
    }
    
    components.path = [(components.path ?: @"/") stringByAppendingPathComponent:relativeComponents.join(@"/")];
}

- (void)components:(NSURLComponents *)components popPathComponentsWithCount:(NSInteger)count
{
    NSArray *relativeComponents = [self componentsFromPath:components.path];
    NSAssert(count < relativeComponents.count, @"we don't have enough components to pop back that far");
    components.path = [@"/" stringByAppendingString:relativeComponents.snip(count).join(@"/")];
}

- (void)components:(NSURLComponents *)components updateParameters:(NSDictionary *)parameters
{
    NSDictionary *updatedParameters = [NSURL nav_parameterDictionaryFromQuery:components.query];
    updatedParameters = updatedParameters.extend(parameters);
    components.query  = [NSURL nav_queryFromParameterDictionary:updatedParameters];
}

- (NSArray *)componentsFromPath:(NSString *)path
{
    return path.split(@"/").select(^(NSString *component) {
        return component.length != 0;
    });
}

# pragma mark - Property Methods

- (NAVAttributesBuilder *)toPath:(NSString *)path
{
    self.attributesPath = path;
    return self;
}

- (NAVAttributesBuilder *)popBack:(NSInteger)popCount
{
    self.popCount = popCount;
    return self;
}

- (NAVAttributesBuilder *)withParameter:(NSString *)parameter options:(NAVParameterOptions)options
{
    if(!self.attributesParameters)
        self.attributesParameters = [NSMutableDictionary new];
    self.attributesParameters[parameter] = @(options);
    return self;
}

- (NAVAttributesBuilder *)withModel:(id)model
{
    self.attributesModel = model;
    return self;
}

- (NAVAttributesBuilder *(^)(NSString *))to
{
    return ^(NSString *path) {
        return [self toPath:path];
    };
}

- (NAVAttributesBuilder *(^)(NSInteger))pop
{
    return ^(NSInteger popCount) {
        return [self popBack:popCount];
    };
}

- (NAVAttributesBuilder *(^)(NSString *, NAVParameterOptions))parameter
{
    return ^(NSString *parameter, NAVParameterOptions options) {
        return [self withParameter:parameter options:options];
    };
}

- (NAVAttributesBuilder *(^)(id))model
{
    return ^(id model) {
        return [self withModel:model];
    };
}

- (NAVAttributesBuilder *)with
{
    return self;
}

@end
