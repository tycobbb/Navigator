//
//  NAVRouter+Pathing.h
//  Created by Ty Cobb on 7/23/14.
//

#import "NAVRouter.h"

@interface NAVRouter (Pathing)
- (void)transitionToPath:(NSString *)path withModel:(id)model;
- (void)transitionToRoot:(NSString *)path;
- (void)transitionBack;
@end
