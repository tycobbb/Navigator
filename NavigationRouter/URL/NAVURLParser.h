//
//  NAVURLParser.h
//  NavigationRouter
//

@import Foundation;

#import "NAVURL.h"

@class NAVURLParsingResults;

@interface NAVURLParser : NSObject
+ (NAVURLParsingResults *)parseFromUrl:(NAVURL *)source toUrl:(NAVURL *)destination;
@end

@interface NAVURLParsingResults : NSObject
@property (copy, nonatomic) NAVURLComponent *componentToReplace;
@property (copy, nonatomic) NSArray *componentsToPush;
@property (copy, nonatomic) NSArray *componentsToPop;
@property (copy, nonatomic) NSArray *parametersToEnable;
@property (copy, nonatomic) NSArray *parametersToDisable;
@end
