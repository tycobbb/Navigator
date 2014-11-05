//
//  NAVURLElement.h
//  NavigationRouter
//

@import Foundation;

typedef NS_ENUM(NSInteger, NAVParameterOptions) {
    NAVParameterOptionsHidden     = 0,
    NAVParameterOptionsVisible    = 1 << 0,
    NAVParameterOptionsUnanimated = 1 << 1,
    NAVParameterOptionsAsync      = 1 << 2,
};

@interface NAVURLElement : NSObject

/**
 @brief String key corresponding to this property.
 
 In the case of NAVURLComponent, this is the component's subpath. In the case of 
 NAVURLParameter, this is the key for the parameters key-value pair.
*/

@property (copy, nonatomic, readonly) NSString *key;

/**
 @brief Initializes a new NAVURLElement
 
 Use of the paramterized key varies based on concrete subtype. See @c key for more 
 information.
 
 @param key The key corresponding to this element.
 @return A new NAVURLElement instance
*/

- (instancetype)initWithKey:(NSString *)key;

@end


@interface NAVURLComponent : NAVURLElement

/// Index of this component in the components list
@property (assign, nonatomic, readonly) NSInteger index;

/**
 @brief Data string corresponding to this component
 
 This string can theoretically contain any non-reserved character, but is typically
 used pass the id of a data object to the corresponding view.
*/

@property (copy  , nonatomic, readonly) NSString *data;

/**
 @brief Initializes a new NAVURLComponent
 
 Components are subpaths in the URL representing a view in the navigation stack. They may
 embed an optional data string.

 @param key   The subpath for this component
 @param data  The data string corresponding to this element (optional)
 @param index The index of this path component

 @return A new NAVURLComponent
*/

- (instancetype)initWithKey:(NSString *)key data:(NSString *)data index:(NSInteger)index;

@end

@interface NAVURLParameter : NAVURLElement
@property (assign, nonatomic, readonly) BOOL isVisible;
@property (assign, nonatomic, readonly) NAVParameterOptions options;
@property (copy  , nonatomic, readonly) NSString *value;
@end
