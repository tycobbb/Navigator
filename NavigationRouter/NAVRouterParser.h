//
//  NAVRouterParser.h
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURL.h"

@class NAVRouter;

@protocol NAVRouterParser <NSObject>
- (NSDictionary *)router:(NAVRouter *)router componentsForTransitionFromURL:(NAVURL *)sourceURL toURL:(NAVURL *)destinationURL;
@end

//
// URL Parsing Components
//

extern NSString * const NAVURLKeyComponentToReplace;
extern NSString * const NAVURLKeyComponentsToPush;
extern NSString * const NAVURLKeyComponentsToPop;
extern NSString * const NAVURLKeyParametersToEnable;
extern NSString * const NAVURLKeyParametersToDisable;
