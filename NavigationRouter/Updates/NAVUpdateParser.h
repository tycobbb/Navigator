//
//  NAVURLParser.h
//  NavigationRouter
//

#import "NAVUpdate.h"

@interface NAVUpdateParser : NSObject
+ (NSArray *)updatesFromAttributes:(NAVAttributes *)attributes;
@end
