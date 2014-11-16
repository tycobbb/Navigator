//
//  NAVURLParserTests.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURLParser.h"

SpecBegin(NAVURLParserTests)

describe(@"The parser", ^{
    
    //
    // Helpers
    //
    
    NAVURLParsingResults *(^NAVTestParse)(NSString *, NSString *) = ^(NSString *fromPath, NSString *toPath) {
        return [NAVURLParser parseFromUrl:URL(fromPath) toUrl:URL(toPath)];
    };
    
    //
    // Tests
    //
    
    it(@"should parse the first route", ^{
        NAVURLParsingResults *result = NAVTestParse(@"test://", @"test://host1/comp1");
        expect(result.componentToReplace.key).to.equal(@"host1");
        expect(result.componentsToPush.count).to.equal(1);
    });
    
    it(@"should not parse anything if there is no change", ^{
        NAVURLParsingResults *result = NAVTestParse(@"test://host1/comp1", @"test://host1/comp1/");
        expect(result.componentToReplace).to.beNil;
        expect(result.componentsToPop.count).to.equal(0);
        expect(result.componentsToPush.count).to.equal(0);
        expect(result.parametersToEnable.count).to.equal(0);
        expect(result.parametersToDisable.count).to.equal(0);
    });
    
    it(@"should parse a host change", ^{
        NAVURLParsingResults *result = NAVTestParse(@"test://host1", @"test://host2");
        expect(result.componentToReplace.key).to.equal(@"host2");
    });
    
    it(@"shouldn not parse a host change if there is not one", ^{
        NAVURLParsingResults *result = NAVTestParse(@"test://host1", @"test://host1/comp1/comp2/");
        expect(result.componentToReplace).to.beNil();
    });
    
    it(@"should parse pushes", ^{
        NAVURLParsingResults *result = NAVTestParse(@"test://host1", @"test://host1/comp1/comp2/");
        expect(result.componentsToPush.count).to.equal(2);
        
        NAVURLComponent *component1 = result.componentsToPush[0];
        NAVURLComponent *component2 = result.componentsToPush[1];
        expect(component1.key).to.equal(@"comp1");
        expect(component2.key).to.equal(@"comp2");
    });
    
    it(@"should not parse pushes if there are none", ^{
        NAVURLParsingResults *result = NAVTestParse(@"test://host1/comp1/", @"test://host1/");
        expect(result.componentsToPush.count).to.equal(0);
    });
    
    it(@"should parse pops", ^{
        NAVURLParsingResults *result = NAVTestParse(@"test://host1/comp1/comp2/", @"test://host1/");
        expect(result.componentsToPop.count).to.equal(2);
        
        NAVURLComponent *component1 = result.componentsToPop[0];
        NAVURLComponent *component2 = result.componentsToPop[1];
        expect(component1.key).to.equal(@"comp1");
        expect(component2.key).to.equal(@"comp2");
    });
    
    it(@"should not parse pops if there are none", ^{
        NAVURLParsingResults *result = NAVTestParse(@"test://host1/", @"test://host1/host2");
        expect(result.componentsToPop.count).to.equal(0);
    });
    
    it(@"should parse a component switch correctly", ^{
        NAVURLParsingResults *result = NAVTestParse(@"test://host1/comp1", @"test://host1/comp2/");
        expect(result.componentsToPop.count).to.equal(1);
        expect(result.componentsToPush.count).to.equal(1);
    });
    
    it(@"should enable parameters correctly", ^{
        NAVURLParsingResults *result = NAVTestParse(@"test://host/comp/?p1=0", @"test://host/comp?p1=1&p2=1");
        expect(result.parametersToEnable.count).to.equal(2);
    });
    
    it(@"should disable parameters correctly", ^{
        NAVURLParsingResults *result = NAVTestParse(@"test://host/comp/?p1=1&p2=1", @"test://host/comp?p1=0");
        expect(result.parametersToDisable.count).to.equal(2);
    });
    
    it(@"should not change parameters unnecessarily", ^{
        NAVURLParsingResults *result = NAVTestParse(@"test://host/comp?p1=0&p2=1", @"test://host/comp?p2=1");
        expect(result.parametersToEnable.count).to.equal(0);
        expect(result.parametersToDisable.count).to.equal(0);
    });
    
});

SpecEnd
