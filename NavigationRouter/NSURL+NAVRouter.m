//
//  NSURL+NAVRouter.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NSURL+NAVRouter.h"
#import "NAVURLParser.h"

@implementation NSURL (NAVRouter)

- (NSDictionary *)nav_parameters
{
    return [[NAVURLParser defaultParser] parametersFromQuery:self.query];
}

- (NAVURLType)nav_URLTypeAgainstScheme:(NSString *)scheme
{
    return [self.scheme isEqualToString:scheme] ? NAVURLTypeInternal : NAVURLTypeExternal;
}
       
@end
