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
        _attributes     = attributes;
        _sourceURL      = [NAVURL_legacy URLWithURL:attributes.sourceURL resolvingAgainstScheme:scheme];
        _destinationURL = [NAVURL_legacy URLWithURL:attributes.destinationURL resolvingAgainstScheme:scheme];
    }
    
    return self;
}

@end
