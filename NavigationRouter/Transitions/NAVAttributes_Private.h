//
//  NAVAttributes_Private.h
//  NavigationRouter
//

#import "NAVAttributes.h"

@interface NAVAttributes () <NSCopying>

@end

@interface NAVAttributes (Operators)

/**
 @brief Creates a new NAVAttributes object with the given data
 
 The other attributes' parameters are preserved, but the data is overwritten with
 the parameterized data.
 
 @param data The data for the copied attributes
 
 @return The copied attributes
*/

- (instancetype)copyWithData:(NSString *)data;

@end
