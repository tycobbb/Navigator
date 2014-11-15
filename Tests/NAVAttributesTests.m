//
//  NAVAttributesTests.m
//  NavigationRouter
//

#import "NAVAttributes.h"
#import "NAVAttributesBuilder.h"

SpecBegin(NAVAttributesTests)

describe(@"the attributes", ^{
   
    it(@"should construct a builder", ^{
        NAVAttributesBuilder *builder = [NAVAttributes builder];
        expect(builder).toNot.beNil();
        expect(builder).to.beKindOf(NAVAttributesBuilder.class);
    });
    
});

SpecEnd
