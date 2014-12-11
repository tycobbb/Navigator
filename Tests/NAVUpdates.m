//
//  NAVUpdates.m
//  NavigationRouter
//

#import "NAVUpdates.h"

@interface NAVUpdates ()
@property (strong, nonatomic) NSArray *updates;
@end

@implementation NAVUpdates

- (instancetype)initWithUpdates:(NSArray *)updates
{
    if(self = [super init]) {
        _updates = updates;
    }
    
    return self;
}

# pragma mark - Accessors

- (NSInteger)count
{
    return self.updates.count;
}

- (NAVUpdate *)objectAtIndexedSubscript:(NSInteger)subscript
{
    return [self.updates objectAtIndexedSubscript:subscript];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [self.updates countByEnumeratingWithState:state objects:buffer count:len];
}

@end