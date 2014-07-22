//
//  NAVUpdate.h
//  Created by Ty Cobb on 7/17/14.
//

#import "NAVRoute.h"
#import "NAVRouterUpdater.h"

typedef NS_ENUM(NSInteger, NAVUpdateType) {
    NAVUpdateTypeUnknown,
    NAVUpdateTypePush,
    NAVUpdateTypePop,
    NAVUpdateTypeReplace,
    NAVUpdateTypeModal,
    NAVUpdateTypeAnimation,
};

@interface NAVUpdate : NSObject

@property (strong, nonatomic, readonly) NAVRoute *route;
@property (assign, nonatomic, readonly) NAVUpdateType type;
@property (assign, nonatomic) BOOL isAnimated;

+ (instancetype)updateWithType:(NAVUpdateType)type route:(NAVRoute *)route;
- (void)performWithUpdater:(id<NAVRouterUpdater>)updater completion:(void(^)(BOOL finished))completion;

@end
