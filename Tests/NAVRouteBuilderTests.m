//
//  NAVRouteBuilderTests.m
//  Navigator
//

#import "NAVRouteBuilder.h"

SpecBegin(NAVRouteBuilderTests)

describe(@"the route builder", ^{
  
    //
    // Mock
    //
    
    NSInteger mockCount = 2;
    
    NAVRouteBuilder *(^mock)() = ^{
        return [[NAVRouteBuilder alloc] initWithRoutes:@{
            @"test1" : [NAVRoute new],
            @"test2" : [NAVRoute new],
        }];
    };
    
    //
    // Tests
    //
    
    it(@"should always have routes", ^{
        NAVRouteBuilder *builder = [[NAVRouteBuilder alloc] initWithRoutes:nil];
        expect(builder.routes).toNot.beNil();
        expect(builder.routes.count).to.equal(0);
        
        builder = mock();
        expect(builder.routes).toNot.beNil();
        expect(builder.routes.count).to.equal(mockCount);
    });
    
    it(@"should add routes", ^{
        NSString *path = @"test3";
        
        NAVRouteBuilder *builder = mock();
        builder.to(path);
        
        expect(builder.routes.count).to.equal(mockCount + 1);
        expect(builder.routes[path]).toNot.beNil();
    });
    
    it(@"should remove routes", ^{
        NAVRouteBuilder *builder = mock();
        builder.remove(@"test1");
        expect(builder.routes.count).to.equal(mockCount - 1);
    });
    
    it(@"should update route types", ^{
        NAVRoute *route = [NAVRoute new];
        route.as(NAVRouteTypeAnimation);
        expect(route.type).to.equal(NAVRouteTypeAnimation);
    });
    
    it(@"should update controllers", ^{
        NAVRoute *route = [NAVRoute new];
        route.controller([NSObject class]);
        expect(route.destination).to.equal([NSObject class]);
    });
    
    it(@"should update animations", ^{
        NAVAnimation *animation = [NAVAnimation new];
        
        NAVRoute *route = [NAVRoute new];
        route.animation(animation);
        
        expect(route.destination).to.equal(animation);
    });
    
});

SpecEnd
