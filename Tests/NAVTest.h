//
//  NAVTest.h
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURL_legacy.h"

@interface NAVTest : NSObject
+ (NAVURL_legacy *(^)(NSString *))URL;
+ (NSString *)scheme;
@end

@interface NSURL (Test)
+ (instancetype)URLWithFormat:(NSString *)format, ...;
@end
