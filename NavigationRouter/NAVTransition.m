//
//  NAVTransition.m
//  NavigationRouter
//

#import "NAVTransition.h"
#import "NAVUpdateParser.h"

@interface NAVTransition ()
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
    
    // get the route for this update
    NAVRoute *route = [self.delegate transition:self routeForUrlElement:update.element];
    if(!route) {
        
    }
    
}

- (void)didCompleteAtIndex:(NSInteger)index
{
    
}

@end
