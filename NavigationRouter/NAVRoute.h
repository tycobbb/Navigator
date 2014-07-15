//
//  NAVRoute.h
//  Created by Ty Cobb on 3/25/14.
//

typedef NS_ENUM(NSInteger, NAVRouteType) {
    NAVRouteTypeStack,
    NAVRouteTypeAnimated,
    NAVRouteTypeModal,
    NAVRouteTypeUnknown
};

@interface NAVRoute : NSObject
@property (assign, nonatomic) NAVRouteType type;
@property (copy  , nonatomic) NSString *component;
@end
