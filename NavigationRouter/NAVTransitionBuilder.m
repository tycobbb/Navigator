//
//  NAVAttributesBuilder.m
//  NavigationRouter
//

#import <YOLOKit/YOLO.h>
#import "NAVTransitionBuilder.h"
#import "NAVAttributes.h"

@interface NAVTransitionBuilder ()
@property (strong, nonatomic) NSMutableArray *transformsB;
@property (strong, nonatomic) id objectB;
@property (strong, nonatomic) id handlerB;
@end

@implementation NAVTransitionBuilder

- (instancetype)init
{
    if(self = [super init]) {
        _transformsB = [NSMutableArray new];
    }
    
    return self;
}

# pragma mark - Output

- (NAVAttributes *(^)(NAVURL *))build
{
    return ^(NAVURL *source) {
        return [self attributesFromSource:source];
    };
}

- (NAVAttributes *)attributesFromSource:(NAVURL *)source
{
    NSParameterAssert(source);
   
    // apply all the transforms to the source URL to genereate the destination
    NAVURL *destination = self.transformsB.inject(source, ^(NAVURL *url, NAVAttributesUrlTransformer transform) {
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

# pragma mark - Chaining

- (NAVTransitionBuilder *(^)(NAVAttributesUrlTransformer))transform
{
    return ^(NAVAttributesUrlTransformer transform) {
        [self.transformsB addObject:transform];
        return self;
    };
}

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

@end

@implementation NAVTransitionBuilder (Convenience)

- (NAVTransitionBuilder *(^)(NSString *))push
{
    return ^(NSString *path) {
        return self.transform(^(NAVURL *url) {
            return [url push:path];
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
