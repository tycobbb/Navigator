//
//  NAVAttributesBuilderTests.m
//  NavigationRouter
//

#import "NAVAttributes.h"
#import "NAVAttributesBuilder.h"

typedef NSString *(^NAVTestHandler)(void);

SpecBegin(NAVAttributesBuilderTests)

describe(@"the attributes builder", ^{
    
    it(@"should apply transforms", ^{
        NAVURL *source = URL(@"rocket://tests");
        NAVURL *destination = URL(@"rocket://tests/are/cool?right=1");
        
        NAVAttributes *attributes = NAVAttributes.builder
            .transform(^(NAVURL *url) { return [url push:@"are"]; })
            .transform(^(NAVURL *url) { return [url push:@"cool"]; })
            .transform(^(NAVURL *url) { return [url updateParameter:@"right" withOptions:NAVParameterOptionsVisible]; })
            .build(source);
        
        expect(attributes.destination.string).to.equal(destination.string);
    });
    
    it(@"should add user objects", ^{
        id object = @9999;
       
        NAVAttributes *attributes = NAVAttributes.builder
            .object(object)
            .build(NAVTest.url);
        
        expect(attributes.userObject).to.equal(object);
    });
    
    it(@"should add handlers", ^{
        NAVTestHandler handler = ^{
            return @"Let's hope this works!";
        };
        
        NAVAttributes *attributes = NAVAttributes.builder
            .handler(handler)
            .build(NAVTest.url);
        
        expect(attributes.handler).to.equal(handler);
    });
    
    it(@"should extract component data", ^{
        NSString *data = @"he134a$*0asdjJA098*23j";
        NSString *component = [NSString stringWithFormat:@"test1::%@", data];
        
        NAVAttributes *attributes = NAVAttributes.builder
            .transform(^(NAVURL *url) { return [url push:component]; })
            .build(NAVTest.url);
        
        expect(attributes.data).to.equal(data);
    });
    
});

SpecEnd
