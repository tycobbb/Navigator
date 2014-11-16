//
//  NAVTransition.m
//  NavigationRouter
//

#import "NAVTransition.h"

@interface NAVTransition ()
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

- (void)startWithUrl:(NAVURL *)url
{
    
}

@end
