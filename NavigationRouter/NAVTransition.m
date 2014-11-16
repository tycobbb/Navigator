//
//  NAVTransition.m
//  NavigationRouter
//

#import "NAVTransition.h"

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

- (void)startWithUrl:(NAVURL *)url
{
    NAVAttributes *attributes = self.attributesBuilder.build(url);
    self.updates = [self updatesFromAttributes:attributes];
}

# pragma mark - Updates

- (NSArray *)updatesFromAttributes:(NAVAttributes *)attributes
{
    return nil;
}

@end
