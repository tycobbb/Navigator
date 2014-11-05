//
//  NAVParameter.h
//  Created by Ty Cobb on 7/17/14.
//

#import "NAVURLElement_legacy.h"

typedef NS_ENUM(NSInteger, NAVParameterOptions_legacy) {
    NAVParameterOptions_legacyHidden     = 0,
    NAVParameterOptions_legacyVisible    = 1 << 0,
    NAVParameterOptions_legacyUnanimated = 1 << 1,
    NAVParameterOptions_legacyAsync      = 1 << 2,
};

@interface NAVURLParameter_legacy : NAVURLElement_legacy

@property (assign, nonatomic) NAVParameterOptions_legacy options;
@property (assign, nonatomic, readonly) BOOL isVisible;

- (instancetype)initWithKey:(NSString *)key options:(NSNumber *)optionsValue;

@end
