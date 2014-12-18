//
//  NAVAttributes.m
//  NavigationRouter
//

#import "NAVAttributes_Private.h"

@implementation NAVAttributes

- (instancetype)cloneWithData:(NSString *)data
{
    NAVAttributes *attributes = [self.class new];
    
    attributes.source = self.source;
    attributes.destination = self.destination;
    attributes.data = data;
    
    return attributes;
}

@end
