//
//  NAVAnimator.h
//  Created by Ty Cobb on 7/17/14.
//

@protocol NAVAnimatorDelegate;

@interface NAVAnimator : NSObject
@property (weak, nonatomic) id<NAVAnimatorDelegate> delegate;
- (void)transitionToVisible:(BOOL)isVisible animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;
@end

@protocol NAVAnimatorDelegate <NSObject>
- (void)animator:(NAVAnimator *)animator transitionToVisible:(BOOL)isVisible animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;
@end
