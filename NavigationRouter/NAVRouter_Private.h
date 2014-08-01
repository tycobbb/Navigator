//
//  NAVRouter_Private.h
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVRouter.h"
#import "NAVUpdate.h"
#import "NAVUpdateBuilder.h"
#import "NAVTransaction.h"
#import "NAVURLParser.h"
#import "NAVRouterNavigationControllerUpdater.h"
#import "NAVRouterConstants.h"
#import "NSError+NAVRouter.h"

#if NAVRouterLogLevel
    #define NAVLog(_format, ...) NSLog(_format, __VA_ARGS__)
#else
    #define NAVLog(_format, ...)
#endif

@interface NAVRouter (Updates)
- (NSArray *)updatesForTransaction:(NAVTransaction *)transaction;
@end
