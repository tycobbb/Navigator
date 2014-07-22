//
//  NSError+NAVRouter.h
//  Created by Ty Cobb on 7/14/14.
//

@import Foundation;

@interface NSError (NAVRouter)
+ (NSError *)nav_errorWithDescription:(NSString *)description;
@end
