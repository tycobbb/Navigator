//
//  NavigationRouterTests.m
//  Created by Ty Cobb on 7/14/14.
//

#import "NAVRouteBuilder.h"

SpecBegin(RouteBuilderTests)

describe(@"Route Builder", ^{
   
    NAVRouteBuilder *builder = [NAVRouteBuilder new];

    it(@"should have a route map", ^{
        expect(builder.routes).notTo.beNil();
    });
    
    it(@"should create a route", ^{
        expect(builder.routes.count).to.equal(0);
        builder.to(@"component").as(NAVRouteTypeRoot);
        expect(builder.routes.count).to.equal(1);
    });
    
    it(@"should bind the component to the route", ^{
        NSString *component = builder.routes.allKeys.firstObject;
        NAVRoute *route     = builder.routes[component];
        expect(route.component).to.equal(component);
    });
    
    it(@"should remove a route", ^{
        NSString *key = builder.routes.allKeys.firstObject;
        builder.remove(key);
        
        expect(key).toNot.beNil();
        expect(builder.routes[key]).to.beNil();
    });

});

SpecEnd
