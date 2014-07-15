//
//  NavigationRouterTests.m
//  NavigationRouterTests
//
//  Created by Ty Cobb on 7/14/14.
//  Copyright (c) 2014 Isobar. All rights reserved.
//

#import "NAVRouteBuilder.h"

SpecBegin(RouteBuilderTests)

describe(@"Route Builder", ^{
   
    __block NAVRouteBuilder *builder = [NAVRouteBuilder new];

    it(@"should have a route map", ^{
        expect(builder.routes).notTo.beNil();
    });
    
    it(@"should create a route", ^{
        expect(builder.routes.count).to.equal(0);
        builder.to(@"component").as(NAVRouteTypeStack);
        expect(builder.routes.count).to.equal(1);
    });
    
    it(@"should remove a route", ^{
        NSString *key = builder.routes.allKeys.firstObject;
        builder.remove(key);
        
        expect(key).toNot.beNil();
        expect(builder.routes[key]).to.beNil();
    });

});

SpecEnd
