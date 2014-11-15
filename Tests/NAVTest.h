//
//  NAVTest.h
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURL.h"
#import "NAVRouterConstants.h"

#define fail() expect(NO).to.equal(YES)

@interface NAVTest : NSObject
+ (NSString *)scheme;
+ (NAVURL *)url;
@end

extern NAVURL * URL(NSString *path);
extern NSArray * URLs(NSArray *paths);
