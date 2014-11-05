//
//  NAVURLParser.m
//  Created by Ty Cobb on 7/18/14.
//

#import <YOLOKit/YOLO.h>
#import "NAVURLParser.h"
#import "YOLT.h"

@implementation NAVURLParser

- (NAVURLTransitionComponents *)router:(NAVRouter *)router transitionComponentsFromURL:(NAVURL_legacy *)sourceURL toURL:(NAVURL_legacy *)destinationURL
{
    NAVURLComponent_legacy *divergentComponent = [self divergentComponentFromURL:sourceURL toURL:destinationURL];
    NSInteger sourceDelta      = [self deltaForComponents:sourceURL.nav_components fromDivergentComponent:divergentComponent];
    NSInteger destinationDelta = [self deltaForComponents:destinationURL.nav_components fromDivergentComponent:divergentComponent];
    
    NAVURLTransitionComponents *components = [NAVURLTransitionComponents new];
    components.componentToReplace  = [divergentComponent isEqual:destinationURL.nav_host] ? destinationURL.nav_host : nil;
    components.componentsToPop     = components.componentToReplace ? @[ ] : sourceURL.nav_components.last(sourceDelta);
    components.componentsToPush    = destinationURL.nav_components.last(destinationDelta);
    components.parametersToEnable  = [self paramatersToEnableFromURL:sourceURL toURL:destinationURL];
    components.parametersToDisable = [self paramatersToDisableFromURL:sourceURL toURL:destinationURL];

    return components;
}

//
// Helpers
//

- (NAVURLComponent_legacy *)divergentComponentFromURL:(NAVURL_legacy *)sourceURL toURL:(NAVURL_legacy *)destinationURL
{
    // if the host if different, then we diverge immediately
    if(![sourceURL.nav_host isEqual:destinationURL.nav_host])
        return destinationURL.nav_host;
    
    // otherwise we need to compare components, and we should always use the URL with the larger
    // component set as the source, in case the divergence point occurs after the last element of
    // the smaller set (like, when the smaller set has 0 items).
    BOOL destinationHasMoreComponents = destinationURL.nav_components.count > sourceURL.nav_components.count;
    NAVURL_legacy *comparing = destinationHasMoreComponents ? destinationURL : sourceURL;
    NAVURL_legacy *compared  = destinationHasMoreComponents ? sourceURL      : destinationURL;
    
    // so find the fisrt component between the two that doesnt match
    return comparing.nav_components.find(^BOOL(NAVURLComponent_legacy *component) {
        if(component.index >= compared.nav_components.count)
            return YES;
        return ![compared.nav_components[component.index] isEqual:component];
    });
}

- (NSInteger)deltaForComponents:(NSArray *)components fromDivergentComponent:(NAVURLComponent_legacy *)component
{
    if(component)
        return components.count - component.index;
    return 0;
}

- (NSArray *)paramatersToEnableFromURL:(NAVURL_legacy *)sourceURL toURL:(NAVURL_legacy *)destinationURL
{
    return destinationURL.nav_parameters.allKeys.map(^(NSString *key) {
        NAVURLParameter_legacy *sourceParameter = sourceURL.nav_parameters[key];
        NAVURLParameter_legacy *destinationParamater = destinationURL.nav_parameters[key];
        return !sourceParameter.isVisible && destinationParamater.isVisible ? destinationParamater : nil;
    });
}

- (NSArray *)paramatersToDisableFromURL:(NAVURL_legacy *)sourceURL toURL:(NAVURL_legacy *)destinationURL
{
    // keys that are disabled may not be in the destination parameters, so we need to merge both the
    // source and destination to ensure a complete set.
    NSArray *keySet = sourceURL.nav_parameters.allKeys.concat(destinationURL.nav_parameters.allKeys).uniq;
    
    return keySet.map(^(NSString *key) {
        NAVURLParameter_legacy *sourceParameter = sourceURL.nav_parameters[key];
        NAVURLParameter_legacy *destinationParameter = destinationURL.nav_parameters[key];
        
        if(!sourceParameter.isVisible || destinationParameter.isVisible)
            return (NAVURLParameter_legacy *)nil;
        
        // we need to make sure we preserve the options on the destination parmaeter, but if there wasn't
        // one we'll have to create a copy from the source object. and make sure that it's not set to visible.
        NAVURLParameter_legacy *parameterToDisable = destinationParameter ?: [sourceParameter copy];
        parameterToDisable.options &= ~NAVParameterOptions_legacyVisible;
        return parameterToDisable;
    });
}

@end
