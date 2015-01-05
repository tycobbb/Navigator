//
//  NAVRoute.h
//  Created by Ty Cobb on 7/14/14.
//

@import Foundation;

#import "NAVRouteDestination.h"

typedef NS_ENUM(NSInteger, NAVRouteType) {
    NAVRouteTypeUnknown,
    NAVRouteTypeStack,
    NAVRouteTypeAnimation,
    NAVRouteTypeModal,
    NAVRouteTypeExternal,
};

@interface NAVRoute : NSObject <NSCopying>
@property (assign, nonatomic) NAVRouteType type;
@property (copy  , nonatomic) NSString *path;
@property (strong, nonatomic) id destination;
@end

extern BOOL NAVRouteTypeIsAnimator(NAVRouteType);
