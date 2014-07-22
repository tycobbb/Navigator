//
//  NAVRoute.h
//  Created by Ty Cobb on 7/14/14.
//

@import Foundation;

typedef NS_ENUM(NSInteger, NAVRouteType) {
    NAVRouteTypeUnknown,
    NAVRouteTypeStack,
    NAVRouteTypeAnimation,
    NAVRouteTypeModal,
    NAVRouteTypeExternal,
};

@interface NAVRoute : NSObject
@property (assign, nonatomic) NAVRouteType type;
@property (copy  , nonatomic) NSString *component;
@end
