//
//  NAVUpdateStack.h
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVUpdate.h"

@interface NAVUpdateStack : NAVUpdate
@property (strong, nonatomic) UIViewController *viewController;
@property (assign, nonatomic) NSInteger index;
@end
