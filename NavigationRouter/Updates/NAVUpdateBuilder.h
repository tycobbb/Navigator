//
//  NAVUpdateBuilder.h
//  NavigationRouter
//

@import Foundation;
@import UIKit;

#import "NAVUpdate.h"
#import "NAVRoute.h"
#import "NAVURL.h"

@protocol NAVUpdateBuilderDelegate;

@interface NAVUpdateBuilder : NSObject

/**
 @brief Provides destination objects to the update builder
 
 The builder will ask its delegate for instances of the update destination objects,
 controller classes or animators, during update construction.
*/

@property (weak, nonatomic) id<NAVUpdateBuilderDelegate> delegate;

/**
 @brief The component to construct the update from
 
 The component corresponds to a stack update, and an update type must also be provided 
 to the builder to properly construct the update.
*/

- (NAVUpdateBuilder *(^)(NAVURLComponent *))component;

/**
 @brief The parameter to construct the update from
 
 The parameter corresponds to an animation update, and the type of animation will be
 inferred from the correspnding route.
*/

- (NAVUpdateBuilder *(^)(NAVURLParameter *))parameter;

/**
 @brief The attribtues corresponding to this update
 
 The attributes will be assosciated with the update and passed to the destination object
 upon creation.
*/
- (NAVUpdateBuilder *(^)(NAVAttributes *))attributes;

/**
 @brief The operation this stack update should run
 
 If the update builder was given a component, then this property is required. Failing to 
 provide it will cause the builder to throw an exception on @c -build.
*/

- (NAVUpdateBuilder *(^)(NAVUpdateType))type;

/**
 @brief Constructs the update from the current builder state
 
 If the builder doesn't have the necessary information to construct the update, it will
 throw an exception.
*/

- (NAVUpdate *)build;

@end

@protocol NAVUpdateBuilderDelegate <NSObject>

@end
