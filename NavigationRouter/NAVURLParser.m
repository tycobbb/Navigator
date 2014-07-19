//
//  NAVURLParser.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURLParser.h"

@implementation NAVURLParser

- (NSDictionary *)router:(NAVRouter *)router componentsForTransitionFromURL:(NAVURL *)sourceURL toURL:(NAVURL *)destinationURL
{
    NAVURLComponent *divergentComponent = destinationURL.nav_components.find(^(NAVURLComponent *component) {
        if(component.index < sourceURL.nav_components.count)
            return NO;
        return [sourceURL.nav_components[component.index] isEqual:component];
    });
    
    NSInteger sourceDelta      = sourceURL.nav_components.count - divergentComponent.index;
    NSInteger destinationDelta = destinationURL.nav_components.count - divergentComponent.index;
    
    NAVURLComponent *hostToReplace = [divergentComponent isEqual:destinationURL.nav_host] ? destinationURL.nav_host : nil;
    NSArray *componentsToPop  = hostToReplace ? @[ ] : sourceURL.nav_components.last(sourceDelta);
    NSArray *componentsToPush = destinationURL.nav_components.last(destinationDelta);
    
    // we'll always have lists for parameters and push/pop components, even if they're empty
    NSMutableDictionary *components = [@{
        NAVURLKeyParametersToEnable  : [self paramatersToEnableFromURL:sourceURL toURL:destinationURL],
        NAVURLKeyParametersToDisable : [self paramatersToDisableFromURL:sourceURL toURL:destinationURL],
        NAVURLKeyComponentsToPop     : componentsToPop,
        NAVURLKeyComponentsToPush    : componentsToPush,
    } mutableCopy];
    
    // we might have a host, if it needs replacing
    [components setValue:hostToReplace forKey:NAVURLKeyComponentToReplace];
    
    return components;
}

//
// Helpers
//

- (NAVURLComponent *)hostToReplaceFromURL:(NAVURL *)sourceURL toURL:(NAVURL *)destinationURL
{
    return [sourceURL.host isEqualToString:destinationURL.host] ? destinationURL.nav_host : nil;
}

- (NSArray *)paramatersToEnableFromURL:(NAVURL *)sourceURL toURL:(NAVURL *)destinationURL
{
    return destinationURL.nav_parameters.allKeys.map(^(NSString *key) {
        NAVURLParameter *sourceParameter = sourceURL.nav_parameters[key];
        NAVURLParameter *destinationParamater = destinationURL.nav_parameters[key];
        return !sourceParameter.isVisible && destinationParamater.isVisible;
    });
}

- (NSArray *)paramatersToDisableFromURL:(NAVURL *)sourceURL toURL:(NAVURL *)destinationURL
{
    NSArray *keySet = sourceURL.nav_parameters.allKeys.concat(destinationURL.nav_parameters.allKeys).uniq;
    return keySet.map(^(NSString *key) {
        NAVURLParameter *sourceParameter = sourceURL.nav_parameters[key];
        NAVURLParameter *destinationParameter = destinationURL.nav_parameters[key];
        return sourceParameter.isVisible && !destinationParameter.isVisible;
    });
}

@end
