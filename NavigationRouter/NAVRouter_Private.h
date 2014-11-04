//
//  NAVRouter_Private.h
//  Created by Ty Cobb on 7/18/14.
//

#import <YOLOKit/YOLO.h>

#import "NAVRouter.h"
#import "NAVUpdate.h"
#import "NAVUpdateBuilder.h"
#import "NAVAnimatorModal.h"
#import "NAVTransaction.h"
#import "NAVURLParser.h"
#import "NAVNavigationControllerUpdater.h"
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
