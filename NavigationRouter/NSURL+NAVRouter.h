//
//  NSURL+NAVRouter.h
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVURLParameter.h"

typedef NS_ENUM(SInt32, NAVURLType) {
    NAVURLTypeInternal,
    NAVURLTypeExternal
};

@interface NSURL (NAVRouter)
- (NSDictionary *)nav_parameters;
- (NAVURLType)nav_URLTypeAgainstScheme:(NSString *)scheme;
@end
