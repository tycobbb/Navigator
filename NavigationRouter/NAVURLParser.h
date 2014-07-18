//
//  NAVURLParser.h
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVURLParameter.h"

@interface NAVURLParser : NSObject

+ (instancetype)defaultParser;

- (NSDictionary *)parametersFromQuery:(NSString *)query;
- (NSString *)queryFromParameters:(NSDictionary *)parameters;

@end
