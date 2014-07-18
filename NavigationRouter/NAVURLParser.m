//
//  NAVURLParser.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVURLParser.h"
#import "NSURL+NAVRouter.h"

#define NAVParameterOptionsValid (NAVParameterOptionsHidden | NAVParameterOptionsVisible | NAVParameterOptionsAnimated)

@implementation NAVURLParser

+ (instancetype)defaultParser
{
    static NAVURLParser *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    
    return instance;
}

# pragma mark - Parameters

- (NSDictionary *)parametersFromQuery:(NSString *)query
{
    NSArray *parameterStrings = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] initWithCapacity:parameterStrings.count];
    
    for(NSString *parameterString in parameterStrings)
    {
        NSArray *parameterComponents = [parameterString componentsSeparatedByString:@"="];
        if(parameterComponents.count == 2)
            paramaters[parameterComponents[0]] = [[NAVURLParameter alloc] initWithComponent:parameterComponents[0] options:parameterComponents[1]];
    }
    
    return [paramaters copy];
}

- (NSString *)queryFromParameters:(NSDictionary *)parameters
{
    NSMutableArray *parameterStrings = [NSMutableArray new];
    
    for(NSString *key in parameters)
    {
        NAVURLParameter *parameter = parameters[key];
        if(parameter.options & NAVParameterOptionsValid)
            [parameterStrings addObject:[NSString stringWithFormat:@"%@=%d", key, parameter.options]];
    }
    
    return [parameterStrings componentsJoinedByString:@"&"];
}

@end