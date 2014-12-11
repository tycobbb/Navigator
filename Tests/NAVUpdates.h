//
//  NAVUpdates.h
//  NavigationRouter
//

@import Foundation;

#import "NAVUpdate.h"

@interface NAVUpdates : NSObject <NSFastEnumeration>

@property (nonatomic, readonly) NSInteger count;

- (instancetype)initWithUpdates:(NSArray *)updates;
- (NAVUpdate *)objectAtIndexedSubscript:(NSInteger)updates;

@end
