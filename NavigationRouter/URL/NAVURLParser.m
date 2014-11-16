//
//  NAVURLParser.m
//  NavigationRouter
//

#import <YOLOKit/YOLO.h>
#import "NAVURLParser.h"

@implementation NAVURLParser

+ (NAVURLParsingResults *)parseFromUrl:(NAVURL *)source toUrl:(NAVURL *)destination
{
    // find the deltas beween the diff'd component index and the number of components in each url
    NSInteger componentIndex   = [self divergingIndexFromUrl:source toUrl:destination];
    NSInteger sourceDelta      = [self components:source.components deltaFromIndex:componentIndex];
    NSInteger destinationDelta = [self components:destination.components deltaFromIndex:componentIndex];
    
    // find the parameters that are changing
    NSArray *parametersToDisable = [self parametersToDisableFromUrl:source toUrl:destination];
    NSArray *parametersToEnable  = [self parametersToEnableFromUrl:source toUrl:destination];
    
    // check if we're replacing a component
    BOOL shouldReplaceRoot = componentIndex == 0;
    
    // generate the results
    NAVURLParsingResults *results = [NAVURLParsingResults new];
    
    results.componentToReplace  = shouldReplaceRoot ? destination[0] : nil;
    results.componentsToPop     = shouldReplaceRoot ? nil : source.components.last(sourceDelta);
    results.componentsToPush    = destination.components.last(destinationDelta);
    results.parametersToEnable  = parametersToEnable;
    results.parametersToDisable = parametersToDisable;
    
    return results;
}

//
// Helpers
//

+ (NSInteger)divergingIndexFromUrl:(NAVURL *)sourceUrl toUrl:(NAVURL *)destinationUrl
{
    for(NAVURLComponent *source in sourceUrl.components) {
        // get the matching destination component
        NAVURLComponent *destination = destinationUrl[source.index];
        
        // if we find a component that's different, then return it immediately
        if(![source isEqual:destination]) {
            return destination.index;
        }
    }
    
    return destinationUrl.components.count;
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

@implementation NAVURLParsingResults @end
