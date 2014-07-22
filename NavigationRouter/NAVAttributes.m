//
//  NAVAttributes.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVAttributes.h"

@implementation NAVAttributes

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@"\n\tsource: %@\n\tdestination: %@", self.sourceURL, self.destinationURL];
}

@end
