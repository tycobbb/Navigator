//
//  NAVURLComponent.h
//  Created by Ty Cobb on 7/18/14.
//

@interface NAVURLComponent : NSObject

@property (copy  , nonatomic, readonly) NSString *component;
@property (assign, nonatomic, readonly) NSInteger index;

- (instancetype)initWithComponent:(NSString *)component index:(NSInteger)index;

@end
