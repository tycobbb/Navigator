//
//  NAVCollections.h
//  Created by Ty Cobb on 7/18/14.
//

@import Foundation;

#import <YOLOKit/YOLO.h>

@interface NSArray (NAVCollections)
- (NSArray *(^)(id))nav_append;
- (NSArray *(^)(NSInteger, id))nav_replace;
@end

@interface NSMutableArray (NAVCollections)
- (NSMutableArray *(^)(id))nav_pushFront;
- (NSMutableArray *(^)(id))nav_push;
- (id)nav_pop;
@end

@interface NSDictionary (NAVCollections)
- (NSDictionary *(^)(id, id))nav_set;
- (NSDictionary *(^)(id, ...))nav_without;
- (NSDictionary *(^)(void(^)(id, id)))nav_each;
- (NSDictionary *(^)(id(^)(id, id)))nav_map;
@end
