//
//  NAVURLTests.m
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURL.h"

SpecBegin(NAVURLTest)

describe(@"URL", ^{
    
    //
    // Helpers
    //
    
    NAVURL *(^NAVTestURL)(NSString *) = ^(NSString *path) {
        return [NAVURL URLWithURL:[NSURL URLWithString:path] resolvingAgainstScheme:@"test"];
    };
    
    //
    // Tests
    //
    
    it(@"should construct a host-only URL correctly", ^{
        NAVURL *testURL = NAVTestURL(@"test://host1");
        expect(testURL.nav_host.component).to.equal(@"host1");
        expect(testURL.nav_host.index).to.equal(0);
        expect(testURL.nav_components.count).to.equal(0);
        expect(testURL.nav_parameters.count).to.equal(0);
    });
    
    it(@"should construct a URL with a path correctly", ^{
        NAVURL *testURL = NAVTestURL(@"test://host1/comp1/comp2/");
        expect(testURL.nav_components.count).to.equal(2);
        expect(testURL[0].component).to.equal(@"comp1");
        expect(testURL[1].component).to.equal(@"comp2");
    });
    
    it(@"should construct a URL with a query string correctly", ^{
        NAVURL *testURL = NAVTestURL(@"test://host/comp1/?param1=&param2=1");
        expect(testURL.nav_components.count).to.equal(1);
        expect(testURL.nav_parameters.count).to.equal(2);
        expect(testURL[@"param1"].options).to.equal(NAVParameterOptionsHidden);
        expect(testURL[@"param2"].options).to.equal(NAVParameterOptionsVisible);
    });
    
});

SpecEnd
