//
//  NAVRouterTests.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRouter.h"

SpecBegin(NAVRouterTest)

describe(@"Router", ^{
    
    NAVRouter *router = [[NAVRouter alloc] initWithScheme:NAVTest.scheme];
    
    it(@"should have a scheme", ^{
        expect(router.scheme).to.equal(NAVTest.scheme);
        expect(router.currentURL).to.equal([NSURL URLWithFormat:@"%@://", NAVTest.scheme]);
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
    
    it(@"should set the initial view controller", ^{
        
    });
    
});

SpecEnd
