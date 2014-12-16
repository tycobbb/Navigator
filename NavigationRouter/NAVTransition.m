//
//  NAVTransition.m
//  NavigationRouter
//

#import "NAVTransition.h"
#import "NAVUpdateParser.h"
#import "NAVRouterUtilities.h"
#import "NAVRouterConstants.h"

@interface NAVTransition () <NAVUpdateDelegate>
@property (strong, nonatomic) NAVAttributes *attributes;
@property (strong, nonatomic) NSArray *updates;
@end

@implementation NAVTransition

- (instancetype)init
{
    return [self initWithAttributes:nil];
}

- (instancetype)initWithAttributes:(NAVAttributes *)attributes
{
    NSParameterAssert(attributes);
    
    if(self = [super init]) {
        _attributes = attributes;
    }
    
    return self;
}

- (void)start
{
    // and parse it into a sequence of updates
    self.updates = [NAVUpdateParser updatesFromAttributes:self.attributes];
   
    // we'll respond to update lifecycle events
    for(NAVUpdate *update in self.updates) {
        update.delegate = self;
    }
    
    // kick off the update execution
    [self executeUpdateAtIndex:0];
}

- (void)failWithError:(NSError *)error
{
    [self finishAtIndex:0 error:error];
}

+ (NAVTransitionBuilder *)builder
{
    return [NAVTransitionBuilder new];
}

# pragma mark - Execution

- (void)executeUpdateAtIndex:(NSInteger)index
{
    // if we've run out of updates, then we're done
    if(index >= self.updates.count) {
        [self finishAtIndex:index error:nil];
        return;
    }
    
    NAVUpdate *update = self.updates[index];
    
    // populate the update with its destination, etc.
    [self.delegate transition:self prepareUpdate:update];
    
    // run the update, and then kick off the next update when it's finished
    [self.delegate transition:self performUpdate:update completion:^(BOOL finished) {
        [self executeUpdateAtIndex:index + 1];
    }];
}

- (void)finishAtIndex:(NSInteger)index error:(NSError *)error
{
    // call the completion and then clear it
    nav_call(self.completion)(error);
    self.completion = nil;
    
    // tell the delegate we completed, if that's the case
    if(!error) {
        [self.delegate transitionDidComplete:self];
    }
}

# pragma mark - NAVUpdateDelegate

- (BOOL)shouldAnimateUpdate:(NAVUpdate *)update
{
    return self.isAnimated;
}

@end
