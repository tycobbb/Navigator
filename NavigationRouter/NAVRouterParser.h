//
//  NAVRouterParser.h
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURL_legacy.h"
#import "NAVURLTransitionComponents.h"

@class NAVRouter;

@protocol NAVRouterParser <NSObject>
- (NAVURLTransitionComponents *)router:(NAVRouter *)router transitionComponentsFromURL:(NAVURL_legacy *)sourceURL toURL:(NAVURL_legacy *)destinationURL;
@end
