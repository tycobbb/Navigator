//
//  NAVTransaction.m
//  Created by Ty Cobb on 7/15/14.
//

#import "NAVTransaction.h"

@implementation NAVTransaction

- (instancetype)initWithAttributes:(NAVAttributes *)attributes scheme:(NSString *)scheme
{
    if(self = [super init])
    {
        _attributes = attributes;
        _sourceURL      = [NAVURL URLWithURL:attributes.sourceURL resolvingAgainstScheme:scheme];
        _destinationURL = [NAVURL URLWithURL:attributes.destinationURL resolvingAgainstScheme:scheme];
    }
    
    return self;
}

@end
