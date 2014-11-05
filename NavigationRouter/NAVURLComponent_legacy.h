//
//  NAVURLComponent_legacy.h
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURLElement_legacy.h"

@interface NAVURLComponent_legacy : NAVURLElement_legacy
@property (assign, nonatomic) NSInteger index;
- (instancetype)initWithKey:(NSString *)key index:(NSInteger)index;
@end
