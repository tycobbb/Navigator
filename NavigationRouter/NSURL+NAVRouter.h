//
//  NSURL+NAVRouter.h
//  Created by Ty Cobb on 3/25/14.
//

typedef NS_ENUM(SInt32, NAVURLType) {
    NAVURLTypeInternal,
    NAVURLTypeExternal
};

@interface NSURL (NAVRouter)
- (NAVURLType)nav_type;
@end
