//
//  NAVRouter_Private.h
//  Navigator
//

@import ObjectiveC;

#import "NAVRouter_Subclass.h"
#import "NAVTransitionBuilder_Private.h"
#import "NAVUpdateStack.h"
#import "NAVUpdateAnimation.h"
#import "NAVAnimationModal.h"
#import "NAVNavigationControllerUpdater.h"
#import "NAVAnimationCachingFactory.h"
#import "NAVCollections.h"

@interface NAVRouter () <NAVTransitionBuilderDelegate, NAVTransitionDelegate, NAVAnimationDelegate, NAVNavigationControllerUpdaterDelegate>
@property (copy  , nonatomic) NSDictionary *routes;
@property (strong, nonatomic) NAVTransition *currentTransition;
@property (strong, nonatomic) NAVTransition *lastTransition;
@property (strong, nonatomic) NSMutableArray *transitionQueue;
@property (strong, nonatomic) NAVAnimationCachingFactory *cachingFactory;
@property (assign, nonatomic) BOOL isReady;
@end

@interface NAVRouterPrototype : NSObject
@property (strong, nonatomic) NAVRouter *instance;
@end
