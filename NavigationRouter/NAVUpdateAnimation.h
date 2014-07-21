//
//  NAVUpdateAnimation.h
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVUpdate.h"
#import "NAVAnimator.h"

@interface NAVUpdateAnimation : NAVUpdate
@property (strong, nonatomic) NAVAnimator *animator;
@property (assign, nonatomic) BOOL isAsynchronous;
@property (assign, nonatomic) BOOL isVisible;
@end
