//
//  NAVRouter+Pathing.h
//  Created by Ty Cobb on 7/23/14.
//

#import "NAVRouter.h"

@interface NAVRouter (Pathing)

- (void)transitionToPath:(NSString *)path withModel:(id)model;
- (void)transitionToRoot:(NSString *)path;
- (void)transitionBack;

- (void)presentScreen:(NSString *)screen animated:(BOOL)animated;
- (void)dismissScreen:(NSString *)screen animated:(BOOL)animated;
- (void)updateParameter:(NSString *)parameter withOptions:(NAVParameterOptions)options;

@end
