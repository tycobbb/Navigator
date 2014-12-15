//
//  NAVTransition.m
//  NavigationRouter
//

#import "NAVTransition.h"
#import "NAVUpdateParser.h"
#import "NAVRouterUtilities.h"
#import "NAVRouterConstants.h"

@interface NAVTransition () <NAVUpdateDelegate>
@property (strong, nonatomic) NAVAttributesBuilder *attributesBuilder;
@property (strong, nonatomic) NSArray *updates;
@end

@implementation NAVTransition

- (instancetype)init
{
    return [self initWithAttributesBuilder:nil];
}

- (instancetype)initWithAttributesBuilder:(NAVAttributesBuilder *)attributesBuilder
{
    NSParameterAssert(attributesBuilder);
    
    if(self = [super init]) {
        _attributesBuilder = attributesBuilder;
    }
    
    return self;
}

- (void)startFromUrl:(NAVURL *)url
{
    // generate the attributes with our start URL
    NAVAttributes *attributes = self.attributesBuilder.build(url);
   
    // and parse it into a sequence of updates
    self.updates = [NAVUpdateParser updatesFromAttributes:attributes];
   
    // we'll respond to update lifecycle events
    for(NAVUpdate *update in self.updates) {
        update.delegate = self;
    }
    
    // kick off the update execution
    [self executeUpdateAtIndex:0];
}

- (void)executeUpdateAtIndex:(NSInteger)index
{
    // if we've run out of updates, then we're done
    if(index >= self.updates.count) {
        [self didCompleteAtIndex:index];
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

- (void)didCompleteAtIndex:(NSInteger)index
{
    [self.delegate transitionDidComplete:self];
}

# pragma mark - NAVUpdateDelegate

- (BOOL)shouldAnimateUpdate:(NAVUpdate *)update
{
    return self.isAnimated;
}

@end
