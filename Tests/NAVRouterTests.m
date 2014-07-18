//
//  NAVRouterTests.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRouter.h"

SpecBegin(NAVRouterTests)

describe(@"Router", ^{
    
    NAVRouter *router = [[NAVRouter alloc] initWithScheme:@"navtest"];
    
    it(@"should have a scheme", ^{
        expect(router.scheme).toNot.beNil();
    });
    
    it(@"should create routes", ^{
        [router updateRoutes:^(NAVRouteBuilder *route) {
            route.to(@"home").as(NAVRouteTypeRoot);
            route.to(@"detail").as(NAVRouteTypeDetail);
            route.to(@"animation").as(NAVRouteTypeAnimation);
            route.to(@"modal").as(NAVRouteTypeModal);
            route.to(@"http").as(NAVRouteTypeExternal);
        }];
    });
    
});

SpecEnd
