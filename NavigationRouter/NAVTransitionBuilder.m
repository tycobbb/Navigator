//
//  NAVAttributesBuilder.m
//  NavigationRouter
//

#import "NAVTransitionBuilder_Private.h"

@interface NAVTransitionBuilder ()
@property (strong, nonatomic) NSMutableArray *transformsB;
@property (strong, nonatomic) id objectB;
@property (strong, nonatomic) id handlerB;
@property (strong, nonatomic) id completionB;
@property (assign, nonatomic) BOOL animatedB;
@end

@implementation NAVTransitionBuilder

- (instancetype)init
{
    if(self = [super init]) {
        _transformsB = [NSMutableArray new];
        _animatedB   = YES;
    }
    
    return self;
}

# pragma mark - Output

- (NAVTransition *(^)(NAVURL *))build
{
    return ^(NAVURL *source) {
        return [self transitionFromSource:source];
    };
}

- (NAVTransition *)transitionFromSource:(NAVURL *)source
{
    // create the attributes, transition
    NAVAttributes *attributes = [self attributesFromSource:source];
    NAVTransition *transition = [[NAVTransition alloc] initWithAttributes:attributes];
    
    transition.isAnimated = self.animatedB;
    transition.completion = self.completionB;
   
    // clean up potentially leaky builder properties
    self.handlerB = nil;
    self.completionB = nil;
    
    return transition;
}

- (NAVAttributes *)attributesFromSource:(NAVURL *)source
{
    NSParameterAssert(source);
   
    // sequentially apply transforms to source URL to generate the destination
    NAVURL *destination = self.transformsB.inject(source, ^(NAVURL *url, NAVTransitionUrlTransformer transform) {
        return transform(url);
    });
    
    // TODO: need to better handle what happens when a transform returns nil
    if(!destination) {
        return nil;
    }
   
    // create the attributes
    NAVAttributes *attributes = [NAVAttributes new];
    
    attributes.source      = source;
    attributes.destination = destination;
    attributes.data        = destination.lastComponent.data;
    attributes.handler     = self.handlerB;
    attributes.userObject  = self.objectB;
    
    return attributes;
}

# pragma mark - Queueing

- (void (^)(void (^)(NSError *)))start
{
    return ^(void(^completion)(NSError *)) {
        [self setCompletionB:completion];
        [self.delegate enqueueTransitionForBuilder:self];
    };
}

- (void (^)(void (^)(void)))enqueue
{
    return ^(void(^completion)(void)){
        // mark the transition as enqueued
        self.shouldEnqueue = YES;
        
        // then run the normal start behavior
        self.start(^(NSError *error) {
            nav_call(completion)();
        });
    };
}

@end

@implementation NAVTransitionBuilder (Chaining)

- (NAVTransitionBuilder *(^)(id))object
{
    return ^(id object) {
        self.objectB = object;
        return self;
    };
}

- (NAVTransitionBuilder *(^)(id))handler
{
    return ^(id handler) {
        self.handlerB = handler;
        return self;
    };
}

- (NAVTransitionBuilder *(^)(BOOL))animated
{
    return ^(BOOL animated) {
        self.animatedB = animated;
        return self;
    };
}

@end

@implementation NAVTransitionBuilder (URLs)

- (NAVTransitionBuilder *(^)(NAVTransitionUrlTransformer))transform
{
    return ^(NAVTransitionUrlTransformer transform) {
        [self.transformsB addObject:transform];
        return self;
    };
}

- (NAVTransitionBuilder *(^)(NSString *))push
{
    return ^(NSString *path) {
        return self.transform(^(NAVURL *url) {
            return [url push:path];
        });
    };
}

- (NAVTransitionBuilder *(^)(NSString *))data
{
    return ^(NSString *data) {
        return self.transform(^(NAVURL *url) {
            return [url setData:data];
        });
    };
}

- (NAVTransitionBuilder *(^)(NSInteger))pop
{
    return ^(NSInteger count) {
        return self.transform(^(NAVURL *url) {
            return [url pop:count];
        });
    };
}

- (NAVTransitionBuilder *(^)(NSString *, NAVParameterOptions))parameter
{
    return ^(NSString *key, NAVParameterOptions options) {
        return self.transform(^(NAVURL *url) {
            return [url updateParameter:key withOptions:options];
        });
    };
}

@end
