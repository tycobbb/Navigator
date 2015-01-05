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
    // parse a sequence of updates from our attributes
    self.updates = [NAVUpdateParser updatesFromAttributes:self.attributes];
    
    for(NAVUpdate *update in self.updates) {
        update.delegate = self;
    }
    
    // kick off the update execution
    [self.delegate transitionWillStart:self];
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
   
    // if the update is asynchronous, then we want to dispatch it and immediately proceed
    NSInteger nextIndex = index + 1;
    if(update.isAsynchronous) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate transition:self performUpdate:update completion:nil];
        });
        
        [self executeUpdateAtIndex:nextIndex];
    }
    // otherwise, run the update and when it's finished proceed to the next udpate
    else {
        [self.delegate transition:self performUpdate:update completion:^(BOOL finished) {
            [self executeUpdateAtIndex:nextIndex];
        }];
    }
}

- (void)finishAtIndex:(NSInteger)index error:(NSError *)error
{
    BOOL finishAsynchronously = self.isAnimated && !error;
    
    // give animated transitions a frame to settle. presenting a modal and then dismissing is in an
    // enqueued transition or completion would fail otherwise, since the system still thinks it's mid-
    // transition without this bonus frame.
    
    optionally_dispatch_async(finishAsynchronously, dispatch_get_main_queue(), ^{
        // call the completion and then clear it
        nav_call(self.completion)(error);
        self.completion = nil;
        
        // tell the delegate we completed, if that's the case
        if(!error) {
            [self.delegate transitionDidComplete:self];
        }       
    });
}

# pragma mark - NAVUpdateDelegate

- (BOOL)shouldAnimateUpdate:(NAVUpdate *)update
{
    return self.isAnimated;
}

@end
