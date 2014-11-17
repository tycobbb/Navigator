//
//  NAVRouter_Private.h
//  NavigationRouter
//

@import ObjectiveC;

#import "NAVRouter_Subclass.h"

@interface NAVRouter ()
@property (copy, nonatomic) NSDictionary *routes;
@end

@interface NAVRouterPrototype : NSObject
@property (strong, nonatomic) NAVRouter *instance;
@end
