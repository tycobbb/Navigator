//
//  NAVURLTests.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURL.h"

SpecBegin(NAVURLTest)

describe(@"URL", ^{
    
    //
    // Tests
    //
    
    it(@"should construct a host-only URL correctly", ^{
        NAVURL *testURL = NAVTest.URL(@"test://host1");
        expect(testURL.nav_host.component).to.equal(@"host1");
        expect(testURL.nav_host.index).to.equal(0);
        expect(testURL.nav_components.count).to.equal(0);
        expect(testURL.nav_parameters.count).to.equal(0);
    });
    
    it(@"should construct a URL with a path correctly", ^{
        NAVURL *testURL = NAVTest.URL(@"test://host1/comp1/comp2/");
        expect(testURL.nav_components.count).to.equal(2);
        expect(testURL[0].component).to.equal(@"comp1");
        expect(testURL[1].component).to.equal(@"comp2");
    });
    
    it(@"should construct a URL with a query string correctly", ^{
        NAVURL *testURL = NAVTest.URL(@"test://host/comp1/?param1=&param2=1");
        expect(testURL.nav_components.count).to.equal(1);
        expect(testURL.nav_parameters.count).to.equal(2);
        expect(testURL[@"param1"].options).to.equal(NAVParameterOptionsHidden);
        expect(testURL[@"param2"].options).to.equal(NAVParameterOptionsVisible);
    });
    
    it(@"should not generate a component after a trailing slash", ^{
        expect(NAVTest.URL(@"test://host/").nav_components.count).to.equal(0);
        expect(NAVTest.URL(@"test://host/comp1/").nav_components.count).to.equal(1);
    });
    
});

SpecEnd
