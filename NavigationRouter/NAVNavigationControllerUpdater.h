//
//  NAVNavigationControllerUpdater.h
//  Created by Ty Cobb on 7/21/14.
//

#import "NAVRouterUpdater.h"

@interface NAVNavigationControllerUpdater : NSObject <NAVRouterUpdater>
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;
@end
