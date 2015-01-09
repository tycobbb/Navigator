//
//  NAVViewControllerFactory_Private.h
//  Navigator
//

#import "NAVViewControllerFactory.h"

@interface NAVViewControllerFactory (Swizzling)

/**
 @brief Replaces @c NAVRouter's default implementation of @c -defaultFactory
 
 The new implementation returns an instance of this class if the original implementation
 returns nil.
*/

+ (void)prepareToLaunch;

@end
