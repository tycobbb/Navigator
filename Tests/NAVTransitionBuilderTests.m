//
//  NAVTransitionBuilderTests.m
//  NavigationRouter
//

#import "NAVAttributes.h"
#import "NAVTransitionBuilder.h"

typedef NSString *(^NAVTestHandler)(void);

SpecBegin(NAVTransitionBuilderTests)

describe(@"the attributes builder", ^{
    
    it(@"should have a source", ^{
        NAVURL *source = URL(nil);
        
        NAVAttributes *attributes = NAVAttributes.builder
            .build(source);
        
        expect(attributes.source).to.equal(source);
        expect(attributes.destination).toNot.beNil();
    });
    
    it(@"should apply transforms", ^{
        NAVURL *source = URL(@"tests");
        NAVURL *destination = URL(@"tests/are/cool?right=1");
        
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
            .build(URL(nil));
        
        expect(attributes.userObject).to.equal(object);
    });
    
    it(@"should add handlers", ^{
        NAVTestHandler handler = ^{
            return @"Let's hope this works!";
        };
        
        NAVAttributes *attributes = NAVAttributes.builder
            .handler(handler)
            .build(URL(nil));
        
        expect(attributes.handler).to.equal(handler);
    });
    
    it(@"should extract component data", ^{
        NSString *data = @"he134a$*0asdjJA098*23j";
        NSString *component = [NSString stringWithFormat:@"test1::%@", data];
        
        NAVAttributes *attributes = NAVAttributes.builder
            .transform(^(NAVURL *url) { return [url push:component]; })
            .build(URL(nil));
        
        expect(attributes.data).to.equal(data);
    });
    
    it(@"should push components", ^{
        NSString *component = @"yeah";
        
        NAVAttributes *attributes = NAVAttributes.builder
            .push(component)
            .build(URL(nil));
        
        expect(attributes.destination.lastComponent.key).to.equal(component);
    });
    
    it(@"should pop components", ^{
        NAVAttributes *attributes = NAVAttributes.builder
            .pop(1)
            .build(URL(@"test"));
        
        expect(attributes.destination.components.count).to.equal(0);
    });
    
    it(@"should update parameters", ^{
        NSString *parameter = @"whoa";
        NAVParameterOptions options = NAVParameterOptionsVisible;
        
        NAVAttributes *attributes = NAVAttributes.builder
            .parameter(@"whoa", NAVParameterOptionsVisible)
            .build(URL(nil));
        
        expect(attributes.destination[parameter].options).to.equal(options);
    });
    
});

SpecEnd
