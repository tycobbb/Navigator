//
//  NAVParameter.h
//  Created by Ty Cobb on 7/17/14.
//

#import "NAVURLElement.h"

typedef NS_ENUM(NSInteger, NAVParameterOptions) {
    NAVParameterOptionsHidden     = 0,
    NAVParameterOptionsVisible    = 1 << 0,
    NAVParameterOptionsUnanimated = 1 << 1,
    NAVParameterOptionsAsync      = 1 << 2,
};

@interface NAVURLParameter : NAVURLElement

@property (assign, nonatomic, readonly) NAVParameterOptions options;
@property (assign, nonatomic, readonly) BOOL isVisible;

- (instancetype)initWithKey:(NSString *)key options:(NSNumber *)optionsValue;

@end
