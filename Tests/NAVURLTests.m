//
//  NAVURLTests.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURL.h"

// spec helpers
NAVURL * url(NSString *path) {
    return [[NAVURL alloc] initWithPath:path];
}

SpecBegin(NAVURLTest)

describe(@"URL", ^{
    
    //
    // Construction
    //
    
    it(@"should have a scheme", ^{
        // failures
        expect(^{ url(@""); }).to.raise(@"rocket.no.scheme.error");
        // successes
        expect(url(@"rocket://").scheme).to.equal(@"rocket");
        expect(url(@"rocket://test").scheme).to.equal(@"rocket");
    });
    
    it(@"should have components", ^{
        expect(url(@"rocket://test").components.count).to.equal(1);
        expect(url(@"rocket://test1/test2").components.count).to.equal(2);
    });
    
    it(@"should have data assosciated to components", ^{
        // failures
        expect(^{ url(@"rocket://test1::1234::5678"); }).to.raise(@"rocket.too.many.data.strings");
        // successes
        expect([url(@"rocket://test::1234").components.firstObject data]).to.equal(@"1234");
    });
    
    it(@"should have parameters and values", ^{
        expect(NO).to.equal(YES);
    });
    
    //
    // Mutation
    //
    
    it(@"should push new components", ^{
        expect(NO).to.equal(YES);
    });
    
    it(@"should pop components", ^{
        expect(NO).to.equal(YES);
    });
    
    it(@"should add values to components", ^{
        expect(NO).to.equal(YES);
    });
    
    it(@"should toggle parameters", ^{
        expect(NO).to.equal(YES);
    });
    
    it(@"should remove hidden parameters", ^{
        expect(NO).to.equal(YES);
    });
    
    //
    // Serialization
    //
    
    it(@"should serialize to a url", ^{
        expect(NO).to.equal(YES);
    });
    
    it(@"should serialize to a string", ^{
        expect(NO).to.equal(YES);
    });
    
});

SpecEnd
