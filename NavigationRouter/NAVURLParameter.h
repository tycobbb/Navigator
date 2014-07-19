//
//  NAVParameter.h
//  Created by Ty Cobb on 7/17/14.
//

typedef NS_ENUM(NSInteger, NAVParameterOptions) {
    NAVParameterOptionsHidden     = 0,
    NAVParameterOptionsVisible    = 1 << 0,
    NAVParameterOptionsUnanimated = 1 << 1,
};

@interface NAVURLParameter : NSObject

@property (copy  , nonatomic, readonly) NSString *component;
@property (assign, nonatomic, readonly) NAVParameterOptions options;
@property (assign, nonatomic, readonly) BOOL isVisible;

- (instancetype)initWithComponent:(NSString *)component options:(NSNumber *)optionsValue;

@end
