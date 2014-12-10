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
            .build(URL(nil));
        
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
