//
//  NAVUpdate.h
//  Created by Ty Cobb on 7/17/14.
//

typedef NS_ENUM(NSInteger, NAVUpdateType) {
    NAVUpdateTypePush,
    NAVUpdateTypePop,
    NAVUpdateTypeReplace,
    NAVUpdateTypeModal,
    NAVUpdateTypeAnimation,
};

@interface NAVUpdate : NSObject
@property (copy  , nonatomic) NSString *component;
@property (assign, nonatomic) NAVUpdateType type;
@end
