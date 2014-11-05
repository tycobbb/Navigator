//
//  NAVRouterDelegate.h
//  Created by Ty Cobb on 7/14/14.
//

@import Foundation;

@class NAVRouter, NAVAttributes;

@protocol NAVRouterDelegate <NSObject> @optional
- (void)router:(NAVRouter *)router didUpdateUrl:(NSURL *)url attributes:(NAVAttributes *)attributes;
@end
