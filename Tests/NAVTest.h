//
//  NAVTest.h
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURL.h"

@interface NAVTest : NSObject
+ (NAVURL *(^)(NSString *))URL;
+ (NSString *)scheme;
@end
