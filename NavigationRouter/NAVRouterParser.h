//
//  NAVRouterParser.h
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURL.h"
#import "NAVURLTransitionComponents.h"

@class NAVRouter;

@protocol NAVRouterParser <NSObject>
- (NAVURLTransitionComponents *)router:(NAVRouter *)router transitionComponentsFromURL:(NAVURL *)sourceURL toURL:(NAVURL *)destinationURL;
@end

//
// URL Parsing Components
//

extern NSString * const NAVComponentsToReplaceKey;
extern NSString * const NAVComponentsToPushKey;
extern NSString * const NAVComponentsToPopKey;
extern NSString * const NAVParametersToEnableKey;
extern NSString * const NAVParametersToDisableKey;
