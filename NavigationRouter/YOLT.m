//
//  YOLT.m
//  Created by Ty Cobb on 7/18/14.
//

#import "YOLT.h"

@implementation NSArray (YOLT)

- (NSArray *(^)(id))nav_append
{
    return ^(id object) {
        return object ? [self arrayByAddingObject:object] : [self copy];
    };
}

@end

@implementation NSDictionary (YOLT)

- (NSDictionary *(^)(id, id))nav_set
{
    return ^(id key, id value) {
        NSMutableDictionary *result = [self copy];
        result[key] = value;
        return [result copy];
    };
}

- (NSDictionary *(^)(id, ...))nav_without {
    return ^(id arg0, ...) {
        va_list args;
        va_start(args, arg0);
        
        NSMutableDictionary *result = [self mutableCopy];
        id key = arg0;
        for(key = arg0 ; key != nil ; key = va_arg(args, id)) {
            [result removeObjectForKey:key];
        }
        
        va_end(args);
        
        return [result copy];
    };
}

- (NSDictionary *(^)(void(^block)(id, id)))nav_each
{
    return ^(void(^block)(id, id)) {
        [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            block(key, obj);
        }];
        return self;
    };
}

- (NSDictionary *(^)(id (^)(id, id)))nav_map
{
    return ^(id(^block)(id, id)) {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:self.count];
        
        for(NSString *key in self)
        {
            id value = block(key, self[key]);
            if(value)
                result[key] = value;
        }
        
        return [result copy];
    };
}

@end
