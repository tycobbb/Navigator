//
//  NAVTest.h
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURL.h"
#import "NAVRouterConstants.h"

@interface NAVTest : NSObject
+ (NSString *)scheme;
@end

extern NAVURL * URL(NSString *path);
extern NSArray * URLs(NSArray *paths);
