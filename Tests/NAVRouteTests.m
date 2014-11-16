//
//  NAVRouteTests.m
//  NavigationRouter
//

#import "NAVRoute.h"

SpecBegin(NAVRouteTests)

describe(@"the route", ^{
    
    it(@"should be copyable", ^{
        NAVRoute *route = [NAVRoute new];
        route.type = NAVRouteTypeStack;
        route.path = @"test";
        route.destination = [NSObject class];
       
        NAVRoute *copy = [route copy];
        expect(copy).toNot.beIdenticalTo(route);
        expect(copy.type).to.equal(route.type);
        expect(copy.path).to.equal(route.path);
        expect(copy.destination).to.equal(route.destination);
    });

});

SpecEnd
