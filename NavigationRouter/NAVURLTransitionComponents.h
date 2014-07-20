//
//  NAVURLTransitionComponents.h
//  Created by Ty Cobb on 7/20/14.
//

#import "NAVURLComponent.h"
#import "NAVURLParameter.h"

@interface NAVURLTransitionComponents : NSObject
@property (strong, nonatomic) NAVURLComponent *componentToReplace;
@property (strong, nonatomic) NSArray *componentsToPush;
@property (strong, nonatomic) NSArray *componentsToPop;
@property (strong, nonatomic) NSArray *parametersToEnable;
@property (strong, nonatomic) NSArray *parametersToDisable;
@end
