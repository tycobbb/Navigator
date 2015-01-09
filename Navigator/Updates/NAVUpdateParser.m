//
//  NAVURLParser.m
//  Navigator
//

#import "NAVUpdateParser.h"
#import "NAVUpdate.h"
#import "NAVAttributes_Private.h"
#import "NAVCollections.h"

@implementation NAVUpdateParser

+ (NSArray *)updatesFromAttributes:(NAVAttributes *)attributes
{
    NSParameterAssert(attributes.source);
    NSParameterAssert(attributes.destination);
   
    // pull out the URLs for convenience of access
    NAVURL *source = attributes.source;
    NAVURL *destination = attributes.destination;
    
    // find the deltas beween the diff'd component index and the number of components in each url
    NSInteger componentIndex   = [self divergingIndexFromUrl:source toUrl:destination];
    NSInteger sourceDelta      = [self components:source.components deltaFromIndex:componentIndex];
    NSInteger destinationDelta = [self components:destination.components deltaFromIndex:componentIndex];

    // check if we're replacing the root component
    BOOL shouldReplaceRoot = componentIndex == 0;
    
    // pull out the correct components/parameters for the update stesp
    NSArray *componentsToReplace = shouldReplaceRoot ? destination.components.first(1) : nil;
    NSArray *componentsToPop     = shouldReplaceRoot ? nil : source.components.last(sourceDelta).first(1);
    NSArray *componentsToPush    = destination.components.last(shouldReplaceRoot ? destinationDelta - 1 : destinationDelta);
    NSArray *parametersToDisable = [self parametersToDisableFromUrl:source toUrl:destination];
    NSArray *parametersToEnable  = [self parametersToEnableFromUrl:source toUrl:destination];
   
    // map the components/parameters into updates. updates are sequenced:
    return @[
        [self updatesWithType:NAVUpdateTypeAnimation elements:parametersToDisable attributes:attributes],
        [self updatesWithType:NAVUpdateTypeReplace elements:componentsToReplace attributes:attributes],
        [self updatesWithType:NAVUpdateTypePop elements:componentsToPop attributes:attributes],
        [self updatesWithType:NAVUpdateTypePush elements:componentsToPush attributes:attributes],
        [self updatesWithType:NAVUpdateTypeAnimation elements:parametersToEnable attributes:attributes]
    ].flatten;
}

//
// Helpers
//

+ (NSArray *)updatesWithType:(NAVUpdateType)type elements:(NSArray *)elements attributes:(NAVAttributes *)source
{
    return (elements ?: @[]).map(^(NAVURLElement *element) {
        NAVAttributes *attributes = [source copyWithData:element.data];
        return [NAVUpdate updateWithType:type element:element attributes:attributes];
    });
}

# pragma mark - URL Parsing

+ (NSInteger)divergingIndexFromUrl:(NAVURL *)sourceUrl toUrl:(NAVURL *)destinationUrl
{
    for(NAVURLComponent *source in sourceUrl.components) {
        // get the matching destination component
        NAVURLComponent *destination = destinationUrl[source.index];
        
        // if we find a component that's different, then return it immediately
        if(![source isEqual:destination]) {
            return source.index;
        }
    }
    
    // if we didn't find any divergent components, then it's whatever comes after our source ends
    return sourceUrl.components.count;
}

+ (NSInteger)components:(NSArray *)components deltaFromIndex:(NSInteger)index
{
    return MAX(components.count - index, 0);
}

+ (NSArray *)parametersToEnableFromUrl:(NAVURL *)sourceUrl toUrl:(NAVURL *)destinationUrl
{
    // map from all the destination parameters
    return destinationUrl.parameters.map(^(NSString *key, NAVURLParameter *destination) {
        // return any parameters that are moving from !visible -> visible
        NAVURLParameter *source = sourceUrl[destination.key];
        return !source.isVisible && destination.isVisible ? [destination copy] : nil;
    });
}

+ (NSArray *)parametersToDisableFromUrl:(NAVURL *)sourceUrl toUrl:(NAVURL *)destinationUrl
{
    // we need to find parameters accross all the keys in both the source and destination
    NSArray *keys = sourceUrl.parameters.allKeys
        .concat(destinationUrl.parameters.allKeys).uniq;
   
    // map from the keys into parameters that should be disabled
    return keys.map(^(NSString *key) {
        NAVURLParameter *source = sourceUrl[key];
        NAVURLParameter *destination = destinationUrl[key];
       
        // ensure the parameter is actually transitioning to _not_ visible
        NAVURLParameter *parameterToDisable = nil;
        if(source.isVisible && !destination.isVisible) {
            // if we don't have any options on the desintation (maybe it doesn't exist) we'll just use .Hidden
            parameterToDisable =
                [[NAVURLParameter alloc] initWithKey:source.key options:destination.options ?: NAVParameterOptionsHidden];
        }
        
        return parameterToDisable;
    });
}

@end
