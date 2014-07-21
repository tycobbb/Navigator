//
//  NAVURLComponent.h
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURLElement.h"

@interface NAVURLComponent : NAVURLElement
@property (assign, nonatomic, readonly) NSInteger index;
- (instancetype)initWithKey:(NSString *)key index:(NSInteger)index;
@end
