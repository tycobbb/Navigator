//
//  NAVTransaction.m
//  Created by Ty Cobb on 7/15/14.
//

#import "NAVTransaction.h"
#import "NAVURLParser.h"
#import "NSURL+NAVRouter.h"

@interface NAVTransaction ()
@property (copy, nonatomic) NSArray *parametersToEnable;
@property (copy, nonatomic) NSArray *parametersToDisable;
@end

@implementation NAVTransaction

- (instancetype)initWithAttributes:(NAVAttributes *)attributes scheme:(NSString *)scheme
{
    if(self = [super init])
    {
        _attributes = attributes;
        _URLType    = [attributes.destinationURL nav_URLTypeAgainstScheme:scheme];
    }
    
    return self;
}

# pragma mark - Paramaters

- (NSArray *)parametersToEnable
{
    if(!_parametersToEnable)
        [self parseParameters];
    return _parametersToEnable;
}

- (NSArray *)parametersToDisable
{
    if(!_parametersToDisable)
        [self parseParameters];
    return _parametersToDisable;
}

- (void)parseParameters
{
    if(self.URLType == NAVURLTypeInternal)
        [self parseParametersFromURL:self.attributes.sourceURL toURL:self.attributes.destinationURL];
}

- (void)parseParametersFromURL:(NSURL *)sourceURL toURL:(NSURL *)destinationURL
{
    NSDictionary *sourceParameters      = [sourceURL nav_parameters];
    NSDictionary *destinationParameters = [destinationURL nav_parameters];
    
    NSMutableArray *parametersToEnable  = [NSMutableArray new];
    NSMutableArray *parametersToDisable = [NSMutableArray new];
    
    NSSet *keySet = [self mergeKeysFromDictionary:sourceParameters andDictionary:destinationParameters];
    for(NSString *key in keySet)
    {
        NAVURLParameter *sourceParamater      = sourceParameters[key];
        NAVURLParameter *destinationParamater = destinationParameters[key];
        
        if(!sourceParamater.isVisible && destinationParamater.isVisible)
            [parametersToEnable addObject:destinationParamater];
        else if(sourceParamater.isVisible && !destinationParamater.isVisible)
            [parametersToDisable addObject:destinationParamater ?: sourceParamater];
    }
    
    self.parametersToEnable  = parametersToEnable;
    self.parametersToDisable = parametersToDisable;
}

//
// Helpers
//

- (NSSet *)mergeKeysFromDictionary:(NSDictionary *)dictionary andDictionary:(NSDictionary *)otherDictionary
{
    NSMutableSet *keySet = [[NSMutableSet alloc] initWithArray:dictionary.allKeys];
    [keySet addObjectsFromArray:otherDictionary.allKeys];
    return [keySet copy];
}

@end
