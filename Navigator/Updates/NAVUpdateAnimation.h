//
//  NAVUpdateAnimation.h
//  Navigator
//

#import "NAVUpdate.h"
#import "NAVAnimation.h"

@interface NAVUpdateAnimation : NAVUpdate

/**
 @brief The animation assosciated with this update
 
 This is created at some point before performing the update, and should not be
 relied upon until the update is being performed.
*/

@property (strong, nonatomic) NAVAnimation *animation;

@end
