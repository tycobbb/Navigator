//
//  NAVRouter_Private.h
//  NavigationRouter
//

@import ObjectiveC;

#import <YOLOKit/YOLO.h>
#import "NAVRouter_Subclass.h"
#import "NAVTransitionBuilder_Private.h"
#import "NAVUpdateStack.h"
#import "NAVUpdateAnimation.h"
#import "NAVAnimationModal.h"
#import "NAVNavigationControllerUpdater.h"
#import "YOLT.h"

#ifdef NAVIGATOR_VIEW
#import "Navigator-View.h"
#endif

@interface NAVRouter () <NAVTransitionBuilderDelegate, NAVTransitionDelegate, NAVAnimationDelegate, NAVNavigationControllerUpdaterDelegate>
@property (copy  , nonatomic) NSDictionary *routes;
@property (strong, nonatomic) NAVTransition *currentTransition;
@property (strong, nonatomic) NAVTransition *lastTransition;
@property (strong, nonatomic) NSMutableArray *transitionQueue;
@property (assign, nonatomic) BOOL isReady;
@end

@interface NAVRouterPrototype : NSObject
@property (strong, nonatomic) NAVRouter *instance;
@end
