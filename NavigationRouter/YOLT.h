//
//  YOLT.h
//  Created by Ty Cobb on 7/18/14.
//

@interface NSDictionary (YOLT)
- (NSDictionary *(^)(id, ...))nav_without;
- (NSDictionary *(^)(void(^)(id, id)))nav_each;
@end
