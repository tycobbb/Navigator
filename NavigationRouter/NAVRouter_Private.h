//
//  NAVRouter_Private.h
//  NavigationRouter
//

@import ObjectiveC;

#import "NAVRouter_Subclass.h"
#import "NAVTransition.h"

@interface NAVRouter () <NAVUpdateBuilderDelegate>
@property (copy  , nonatomic) NSDictionary *routes;
@property (strong, nonatomic) NAVUpdateBuilder *updateBuilder;
@end

@interface NAVRouterPrototype : NSObject
@property (strong, nonatomic) NAVRouter *instance;
@end
