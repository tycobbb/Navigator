//
//  NAVAttributes_Private.h
//  NavigationRouter
//

#import "NAVAttributes.h"

@interface NAVAttributes (Operators)

/**
 @brief Creates a new NAVAttributes object with the given data
 
 The user object, handler, and any existing data are discarded during the cloning 
 process.
 
 @param data The data for the cloned attributes

 @return The cloned attributes
*/

- (instancetype)cloneWithData:(NSString *)data;

@end
