//
//  NAVRouter_Private.h
//  NavigationRouter
//

@import ObjectiveC;

#import <YOLOKit/YOLO.h>
#import "NAVRouter_Subclass.h"
#import "NAVTransition.h"
#import "NAVUpdateStack.h"
#import "NAVUpdateAnimation.h"
#import "NAVAnimationModal.h"
#import "YOLT.h"

@interface NAVRouter () <NAVTransitionDelegate, NAVAnimationDelegate>
@property (copy  , nonatomic) NSDictionary *routes;
@property (strong, nonatomic) NAVTransition *currentTransition;
@property (strong, nonatomic) NAVTransition *lastTransition;
@property (strong, nonatomic) NSMutableArray *transitionQueue;
@end

@interface NAVRouterPrototype : NSObject
@property (strong, nonatomic) NAVRouter *instance;
@end
