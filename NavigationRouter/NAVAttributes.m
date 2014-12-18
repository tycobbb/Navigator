//
//  NAVAttributes.m
//  NavigationRouter
//

#import "NAVAttributes_Private.h"

@implementation NAVAttributes

- (id)copyWithZone:(NSZone *)zone
{
    NAVAttributes *copy = [self.class new];
    
    copy.source = self.source;
    copy.destination = self.destination;
    copy.userObject = self.userObject;
    copy.handler = self.handler;
    copy.data = self.data;
    
    return copy;
}

@end

@implementation NAVAttributes (Operators)

- (instancetype)copyWithData:(NSString *)data
{
    NAVAttributes *result = [self copy];
    result.data = data;
    return result;
}

@end
