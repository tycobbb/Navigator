//
//  NAVRouter.h
//  Created by Ty Cobb on 3/25/14.
//

#import "NAVRouterDelegate.h"
#import "NAVRouterUpdater.h"
#import "NAVRouteBuilder.h"

@interface NAVRouter : NSObject
- (void)updateRoutes:(void(^)(NAVRouteBuilder *route))routingBlock;
@end
