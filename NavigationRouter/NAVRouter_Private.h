//
//  NAVRouter_Private.h
//  NavigationRouter
//

@import ObjectiveC;

#import "NAVRouter_Subclass.h"
#import "NAVTransition.h"
#import "YOLT.h"

@interface NAVRouter () <NAVTransitionDelegate>
@property (copy  , nonatomic) NSDictionary *routes;
@property (strong, nonatomic) NAVTransition *currentTransition;
@property (strong, nonatomic) NAVTransition *lastTransition;
@property (strong, nonatomic) NSMutableArray *transitionQueue;
@end

@interface NAVRouterPrototype : NSObject
@property (strong, nonatomic) NAVRouter *instance;
@end
