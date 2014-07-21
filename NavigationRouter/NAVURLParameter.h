//
//  NAVParameter.h
//  Created by Ty Cobb on 7/17/14.
//

typedef NS_ENUM(NSInteger, NAVParameterOptions) {
    NAVParameterOptionsHidden     = 0,
    NAVParameterOptionsVisible    = 1 << 0,
    NAVParameterOptionsUnanimated = 1 << 1,
    NAVParameterOptionsAsync      = 1 << 2,
};

#import "NAVURLElement.h"

@interface NAVURLParameter : NAVURLElement

@property (assign, nonatomic, readonly) NAVParameterOptions options;
@property (assign, nonatomic, readonly) BOOL isVisible;

- (instancetype)initWithKey:(NSString *)key options:(NSNumber *)optionsValue;

@end
