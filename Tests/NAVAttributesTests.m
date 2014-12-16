//
//  NAVAttributesTests.m
//  NavigationRouter
//

#import "NAVAttributes.h"
#import "NAVTransitionBuilder.h"

SpecBegin(NAVAttributesTests)

describe(@"the attributes", ^{
   
    it(@"should construct a builder", ^{
        NAVTransitionBuilder *builder = [NAVAttributes builder];
        expect(builder).toNot.beNil();
        expect(builder).to.beKindOf(NAVAttributesBuilder.class);
    });
    
});

SpecEnd
