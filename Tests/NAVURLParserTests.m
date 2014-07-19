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
    
    NAVURL *(^NAVTestURL)(NSString *) = ^(NSString *path) {
        return [NAVURL URLWithURL:[NSURL URLWithString:path] resolvingAgainstScheme:@"test"];
    };
    
    NSDictionary *(^NAVTestParse)(NSString *, NSString *) = ^(NSString *fromPath, NSString *toPath) {
        return [parser router:nil componentsForTransitionFromURL:NAVTestURL(fromPath) toURL:NAVTestURL(toPath)];
    };
    
    //
    // Tests
    //
    
    it(@"should recognize host changes", ^{
        NSDictionary *result = NAVTestParse(@"test://host1", @"test://host2");
        expect(result[NAVURLKeyComponentToReplace]).toNot.beNil;
    });
    
});

SpecEnd