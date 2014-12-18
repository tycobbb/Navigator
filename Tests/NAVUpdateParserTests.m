//
//  NAVURLParserTests.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVUpdates.h"
#import "NAVUpdateParser.h"

SpecBegin(NAVUpdateParserTests)

describe(@"The parser", ^{
    
    //
    // Helpers
    //
    
    NAVUpdates *(^NAVTestParse)(NSString *, NSString *) = ^(NSString *fromPath, NSString *toPath) {
        NAVAttributes *attributes = [NAVAttributes new];
        attributes.source = URL(fromPath);
        attributes.destination = URL(toPath);
        return [[NAVUpdates alloc] initWithUpdates:[NAVUpdateParser updatesFromAttributes:attributes]];
    };
    
    //
    // Tests
    //

    it(@"should parse the first route", ^{
        NAVUpdates *updates = NAVTestParse(nil, @"host1/comp1");
        
        expect(updates[0].type).to.equal(NAVUpdateTypeReplace);
        expect(updates[1].type).to.equal(NAVUpdateTypePush);
        
        expect(updates[0].element.key).to.equal(@"host1");
        expect(updates[1].element.key).to.equal(@"comp1");
    });
    
    it(@"should not parse anything if there is no change", ^{
        NAVUpdates *updates = NAVTestParse(@"host1/comp1", @"host1/comp1/");
        expect(updates.count).to.equal(0);
    });
    
    it(@"should parse a host change", ^{
        NAVUpdates *updates = NAVTestParse(@"host1", @"host2");
       
        expect(updates.count).to.equal(1);
        
        expect(updates[0].type).to.equal(NAVUpdateTypeReplace);
        expect(updates[0].element.key).to.equal(@"host2");
    });
    
    it(@"should not parse a host change if there is not one", ^{
        NAVUpdates *updates = NAVTestParse(@"host1", @"host1/comp1/comp2/");
        expect(updates[0].type).toNot.equal(NAVUpdateTypeReplace);
    });
    
    it(@"should parse pushes", ^{
        NAVUpdates *updates = NAVTestParse(@"host1", @"host1/comp1/comp2/");
        
        expect(updates.count).to.equal(2);
    
        expect(updates[0].type).to.equal(NAVUpdateTypePush);
        expect(updates[1].type).to.equal(NAVUpdateTypePush);
        
        expect(updates[0].element.key).to.equal(@"comp1");
        expect(updates[1].element.key).to.equal(@"comp2");
    });
    
    it(@"should assosciate data parameters to the correct attributes", ^{
        NSDictionary *componentMap = @{
            @"host"  : @"1234",
            @"comp1" : @"asdf",
            @"comp2" : @0
        };
        
        NSString *destination = componentMap.map(^(NSString *path, NSString *data){
            return [data isEqual:@0] ? path : @[ path, data ].join(@"::");
        }).join(@"/");
        
        NAVUpdates *updates = NAVTestParse(nil, destination);
        
        for(NAVUpdate *update in updates) {
            NSString *expectedData = componentMap[update.element.key];
            expect(update.attributes.data).to.equal([expectedData isEqual:@0] ? nil : expectedData);
        }
    });
    
    it(@"should not parse pushes if there are none", ^{
        NAVUpdates *updates = NAVTestParse(@"host1/comp1/", @"host1/");
    
        expect(updates.count).to.equal(1);
        expect(updates[0].type).toNot.equal(NAVUpdateTypePush);
    });
    
    it(@"should parse pops", ^{
        NAVUpdates *updates = NAVTestParse(@"host1/comp1/comp2/", @"host1/");
        
        expect(updates.count).to.equal(1);
        expect(updates[0].type).to.equal(NAVUpdateTypePop);
        expect(updates[0].element.key).to.equal(@"comp1");
    });
    
    it(@"should not parse pops if there are none", ^{
        NAVUpdates *updates = NAVTestParse(@"host1/", @"host1/host2");
        
        expect(updates.count).to.equal(1);
        expect(updates[0].type).toNot.equal(NAVUpdateTypePop);
    });
    
    it(@"should parse a component switch correctly", ^{
        NAVUpdates *updates = NAVTestParse(@"host1/comp1", @"host1/comp2/");
        
        expect(updates.count).to.equal(2);
        
        expect(updates[0].type).to.equal(NAVUpdateTypePop);
        expect(updates[1].type).to.equal(NAVUpdateTypePush);
        
        expect(updates[0].element.key).to.equal(@"comp1");
        expect(updates[1].element.key).to.equal(@"comp2");
    });
    
    it(@"should enable parameters correctly", ^{
        NAVUpdates *updates = NAVTestParse(@"host/comp/?p1=0", @"host/comp?p1=1&p2=1");
        
        expect(updates.count).to.equal(2);
        
        for(NAVUpdate *update in updates) {
            NAVURLParameter *parameter = (NAVURLParameter *)update.element;
            expect(update.type).to.equal(NAVUpdateTypeAnimation);
            expect(parameter.options).to.equal(NAVParameterOptionsVisible);
        }
    });
    
    it(@"should disable parameters correctly", ^{
        NAVUpdates *updates = NAVTestParse(@"host/comp/?p1=1&p2=1", @"host/comp?p1=0");
        
        expect(updates.count).to.equal(2);
        
        for(NAVUpdate *update in updates) {
            NAVURLParameter *parameter = (NAVURLParameter *)update.element;
            expect(update.type).to.equal(NAVUpdateTypeAnimation);
            expect(parameter.options).to.equal(NAVParameterOptionsHidden);
        }
    });
    
    it(@"should not change parameters unnecessarily", ^{
        NAVUpdates *updates = NAVTestParse(@"host/comp?p1=0&p2=1", @"host/comp?p2=1");
        expect(updates.count).to.equal(0);
    });
    
});

SpecEnd
