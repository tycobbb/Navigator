//
//  NAVURLParserTests.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURLParser.h"

SpecBegin(NAVURLParserTests)

describe(@"Parser", ^{

    //
    // Components
    //
    
    NAVURLParser *parser = [NAVURLParser new];
    
    //
    // Helpers
    //
    
    NSDictionary *(^NAVTestParse)(NSString *, NSString *) = ^(NSString *fromPath, NSString *toPath) {
        return [parser router:nil componentsForTransitionFromURL:NAVTest.URL(fromPath) toURL:NAVTest.URL(toPath)];
    };
    
    //
    // Tests
    //
    
    it(@"should parse the first route", ^{
        NSDictionary *result = NAVTestParse(@"test://", @"test://host1/comp1");
        expect([result[NAVURLKeyComponentToReplace] component]).to.equal(@"host1");
        expect([result[NAVURLKeyComponentsToPush] count]).to.equal(1);
    });
    
    it(@"shouln not parse anything if there is no change", ^{
        NSDictionary *result = NAVTestParse(@"test://host1/comp1", @"test://host1/comp1/");
        expect([result[NAVURLKeyComponentToReplace] component]).to.beNil;
        result.nav_without(NAVURLKeyComponentToReplace, nil).nav_each(^(NSString *key, NSArray *components) {
            expect(components.count).to.equal(0);
        });
    });
    
    it(@"should parse a host change", ^{
        NSDictionary *result = NAVTestParse(@"test://host1", @"test://host2");
        expect([result[NAVURLKeyComponentToReplace] component]).to.equal(@"host2");
    });
    
    it(@"shouldn not parse a host change if there is not one", ^{
        NSDictionary *result = NAVTestParse(@"test://host1", @"test://host1/comp1/comp2/");
        expect(result[NAVURLKeyComponentToReplace]).to.beNil();
    });
    
    it(@"should parse pushes", ^{
        NSDictionary *result = NAVTestParse(@"test://host1", @"test://host1/comp1/comp2/");
        expect([result[NAVURLKeyComponentsToPush] count]).to.equal(2);

        NAVURLComponent *component1 = result[NAVURLKeyComponentsToPush][0];
        NAVURLComponent *component2 = result[NAVURLKeyComponentsToPush][1];
        expect(component1.component).to.equal(@"comp1");
        expect(component2.component).to.equal(@"comp2");
    });
    
    it(@"should not parse pushes if there are none", ^{
        NSDictionary *result = NAVTestParse(@"test://host1/comp1/", @"test://host1/");
        expect([result[NAVURLKeyComponentsToPush] count]).to.equal(0);
    });
    
    it(@"should parse pops", ^{
        NSDictionary *result = NAVTestParse(@"test://host1/comp1/comp2/", @"test://host1/");
        expect([result[NAVURLKeyComponentsToPop] count]).to.equal(2);
        
        NAVURLComponent *component1 = result[NAVURLKeyComponentsToPop][0];
        NAVURLComponent *component2 = result[NAVURLKeyComponentsToPop][1];
        expect(component1.component).to.equal(@"comp1");
        expect(component2.component).to.equal(@"comp2");
    });
    
    it(@"should not parse pops if there are none", ^{
        NSDictionary *result = NAVTestParse(@"test://host1/", @"test://host1/host2");
        expect([result[NAVURLKeyComponentsToPop] count]).to.equal(0);
    });
    
    it(@"should parse a component switch correctly", ^{
        NSDictionary *result = NAVTestParse(@"test://host1/comp1", @"test://host1/comp2/");
        expect([result[NAVURLKeyComponentsToPop] count]).to.equal(1);
        expect([result[NAVURLKeyComponentsToPush] count]).to.equal(1);
    });
    
});

SpecEnd