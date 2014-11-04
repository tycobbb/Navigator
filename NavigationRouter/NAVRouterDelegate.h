//
//  NAVRouterDelegate.h
//  Created by Ty Cobb on 7/14/14.
//

@import Foundation;

@class NAVRouter;

@protocol NAVRouterDelegate <NSObject> @optional
- (void)router:(NAVRouter *)router didUpdateURL:(NSURL *)url;
@end
