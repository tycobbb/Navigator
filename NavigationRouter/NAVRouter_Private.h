//
//  NAVRouter_Private.h
//  NavigationRouter
//

@import ObjectiveC;

#import "NAVRouter_Subclass.h"
#import "NAVTransition.h"
#import "YOLT.h"

@interface NAVRouter () <NAVUpdateBuilderDelegate, NAVTransitionDelegate>
@property (copy  , nonatomic) NSDictionary *routes;
@property (strong, nonatomic) NAVTransition *currentTransition;
@property (strong, nonatomic) NAVTransition *lastTransition;
@property (strong, nonatomic) NSMutableArray *transitionQueue;
@property (strong, nonatomic) NAVUpdateBuilder *updateBuilder;
@end

@interface NAVRouterPrototype : NSObject
@property (strong, nonatomic) NAVRouter *instance;
@end
