//
//  NAVURLComponents.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURL.h"

@implementation NAVURL

+ (instancetype)URLWithURL:(NSURL *)url resolvingAgainstScheme:(NSString *)scheme
{
    return [[self alloc] initWithURL:url resolvingAgainstBaseURL:YES andScheme:scheme];
}

- (id)initWithURL:(NSURL *)url resolvingAgainstBaseURL:(BOOL)resolve andScheme:(NSString *)scheme
{
    if(self = [super initWithURL:url resolvingAgainstBaseURL:resolve])
    {
        _type = [self.scheme isEqualToString:scheme] ? NAVURLTypeInternal : NAVURLTypeExternal;
        if(_type == NAVURLTypeInternal)
            [self parseInternalComponents];
    }
    
    return self;
}

- (void)parseInternalComponents
{
    _nav_host = self.host ? [[NAVURLComponent alloc] initWithComponent:self.host index:0] : nil;
    _nav_components = [self parseComponentsFromPath:self.path];
    _nav_parameters = [self parseParamatersFromQuery:self.query];
}

//
// Helpers
//

- (NSArray *)parseComponentsFromPath:(NSString *)path
{
    return path.split(@"/").map(^(NSString *component, NSInteger index) {
        return [[NAVURLComponent alloc] initWithComponent:component index:index];
    });
}

- (NSDictionary *)parseParamatersFromQuery:(NSString *)query
{
    // TODO: this is unsafe if there is no the component is nil (ie. parameter is "=")
    return query.split(@"&").map(^(NSString *parameter) {
        NSMutableArray *pair = [parameter.split(@"=") mutableCopy];
        pair[1] = [[NAVURLParameter alloc] initWithComponent:pair[1] options:pair[2]];
        return pair;
    }).dict;
}

@end
