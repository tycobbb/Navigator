//
//  NSURL+NAVRouter.h
//  Created by Ty Cobb on 7/22/14.
//

@interface NSURL (NAVRouter)
+ (NSDictionary *)nav_parameterDictionaryFromQuery:(NSString *)query;
+ (NSString *)nav_queryFromParameterDictionary:(NSDictionary *)dictionary;
@end
