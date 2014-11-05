//
//  NAVURLTransitionComponents.h
//  Created by Ty Cobb on 7/20/14.
//

#import "NAVURLComponent_legacy.h"
#import "NAVURLParameter_legacy.h"

@interface NAVURLTransitionComponents : NSObject
@property (strong, nonatomic) NAVURLComponent_legacy *componentToReplace;
@property (strong, nonatomic) NSArray *componentsToPush;
@property (strong, nonatomic) NSArray *componentsToPop;
@property (strong, nonatomic) NSArray *parametersToEnable;
@property (strong, nonatomic) NSArray *parametersToDisable;
@end
