//
//  YOLT.h
//  Created by Ty Cobb on 7/18/14.
//

@import Foundation;

@interface NSArray (YOLT)
- (NSArray *(^)(id))nav_append;
@end

@interface NSMutableArray (YOLT)
- (NSMutableArray *(^)(id))pushFront;
- (NSMutableArray *(^)(id))push;
- (id)pop;
@end

@interface NSDictionary (YOLT)
- (NSDictionary *(^)(id, id))nav_set;
- (NSDictionary *(^)(id, ...))nav_without;
- (NSDictionary *(^)(void(^)(id, id)))nav_each;
- (NSDictionary *(^)(id(^)(id, id)))nav_map;
@end
