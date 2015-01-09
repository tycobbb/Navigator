//
//  NAVCollections.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVCollections.h"

@implementation NSArray (NAVCollections)

- (NSArray *(^)(id))nav_append
{
    return ^(id object) {
        return object ? [self arrayByAddingObject:object] : [self copy];
    };
}

- (NSArray *(^)(NSInteger, id))nav_replace
{
    return ^(NSInteger index, id object) {
        NSMutableArray *result = [self mutableCopy];
        [result replaceObjectAtIndex:index withObject:object];
        return [result copy];
    };
}

@end

@implementation NSMutableArray (NAVCollections)

- (NSMutableArray *(^)(id))nav_push
{
    return ^(id object) {
        if(object) {
            [self addObject:object];
        }
        
        return self;
    };
}

- (NSMutableArray *(^)(id))nav_pushFront
{
    return ^(id object) {
        if(object) {
            [self insertObject:object atIndex:0];
        }
        return self;
    };
}

- (id)nav_pop
{
    id object = self.lastObject;
    [self removeLastObject];
    return object;
}

@end

@implementation NSDictionary (NAVCollections)

- (NSDictionary *(^)(id, id))nav_set
{
    return ^(id key, id value) {
        NSMutableDictionary *result = [self mutableCopy];
        result[key] = value;
        return [result copy];
    };
}

- (NSDictionary *(^)(id, ...))nav_without
{
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
            if(value) {
                result[key] = value;
            }
        }
        
        return [result copy];
    };
}

@end
