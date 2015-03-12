//
//  NAVTransition.m
//  Navigator
//

#import "NAVTransition.h"
#import "NAVUpdateParser.h"
#import "NAVRouterUtilities.h"

@interface NAVTransition () <NAVUpdateDelegate>
@property (strong, nonatomic) NAVAttributes *attributes;
@property (strong, nonatomic) NSArray *updates;
@property (nonatomic, readonly) BOOL completesAsynchronously;
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
    [self completeAtIndex:0 error:error];
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
        [self completeAtIndex:index error:nil];
        return;
    }
    
    // otherwise, grab the next update and populate it with its destination, etc.
    NAVUpdate *update = self.updates[index];
    [self.delegate transition:self prepareUpdate:update];
   
    // if the update is asynchronous, then we want to dispatch it and immediately proceed
    if(update.isAsynchronous) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate transition:self performUpdate:update completion:nil];
        });
        
        [self executeUpdateAtIndex:index + 1];
    }
    // otherwise, run the update and when it's finished proceed to the next udpate
    else {
        [self.delegate transition:self performUpdate:update completion:^(BOOL finished) {
            [self executeUpdateAtIndex:index + 1];
        }];
    }
}

- (void)completeAtIndex:(NSInteger)index error:(NSError *)error
{
    BOOL completesAsynchronously = !error && self.completesAsynchronously;
   
    optionally_dispatch_async(completesAsynchronously, dispatch_get_main_queue(), ^{
        // call the completion and then clear it
        nav_call(self.completion)(error);
        self.completion = nil;
        
        // tell the delegate we completed, if that's the case
        if(!error) {
            [self.delegate transitionDidComplete:self];
        }       
    });
}

- (BOOL)completesAsynchronously
{
    // certain update types require asynchronous completion. in order to support chaining or enqueuing
    // such updates, the transition will finish on the next run-loop after normal completion if any
    // of its updates completesAsynchronously
    
    for(NAVUpdate *update in self.updates) {
        if(update.completesAsynchrnously) {
            return YES;
        }
    }
    
    return NO;
}

# pragma mark - NAVUpdateDelegate

- (BOOL)shouldAnimateUpdate:(NAVUpdate *)update
{
    return self.isAnimated;
}

@end
