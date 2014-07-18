//
//  NAVParameter.h
//  Created by Ty Cobb on 7/17/14.
//

typedef NS_ENUM(NSInteger, NAVParameterOptions) {
    NAVParameterOptionsHidden   = 1 << 0,
    NAVParameterOptionsVisible  = 1 << 1,
    NAVParameterOptionsAnimated = 1 << 2,
};

@interface NAVURLParameter : NSObject

@property (copy  , nonatomic, readonly) NSString *component;
@property (assign, nonatomic, readonly) NAVParameterOptions options;
@property (assign, nonatomic, readonly) BOOL isVisible;

- (instancetype)initWithComponent:(NSString *)component options:(NSNumber *)optionsValue;

@end
