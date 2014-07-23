//
//  NSURL+NAVRouter.m
//  Created by Ty Cobb on 7/22/14.
//

#import "YOLOKit/YOLO.h"
#import "NSURL+NAVRouter.h"

@implementation NSURL (NAVRouter)

+ (NSDictionary *)nav_parameterDictionaryFromQuery:(NSString *)query
{
    if(!query)
        return @{ };
    
    return query.split(@"&").map(^(NSString *parameter) {
        return parameter.split(@"=");
    }).dict;
}

+ (NSString *)nav_queryFromParameterDictionary:(NSDictionary *)parameters
{
    return parameters.array.map(^(NSArray *pair) {
        return pair.join(@"=");
    }).join(@"&");
}

@end
