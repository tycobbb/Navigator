//
//  NAVUpdate.h
//  Created by Ty Cobb on 7/17/14.
//

typedef NS_ENUM(NSInteger, NAVUpdateType) {
    NAVUpdateTypeUnknown,
    NAVUpdateTypePush,
    NAVUpdateTypePop,
    NAVUpdateTypeReplace,
    NAVUpdateTypeModal,
    NAVUpdateTypeAnimation,
};

#import "NAVRoute.h"
#import "NAVRouterUpdater.h"

@interface NAVUpdate : NSObject

@property (strong, nonatomic, readonly) NAVRoute *route;
@property (assign, nonatomic, readonly) NAVUpdateType type;
@property (assign, nonatomic) BOOL isAnimated;

+ (instancetype)updateWithType:(NAVUpdateType)type route:(NAVRoute *)route;
- (void)performWithUpdater:(id<NAVRouterUpdater>)updater completion:(void(^)(BOOL finished))completion;

@end
