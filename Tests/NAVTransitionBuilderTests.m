//
//  NAVTransitionBuilderTests.m
//  NavigationRouter
//

#import "NAVAttributes.h"
#import "NAVTransitionBuilder_Private.h"

typedef NSString *(^NAVTestHandler)(void);

SpecBegin(NAVTransitionBuilderTests)

describe(@"the attributes builder", ^{
    
    NAVAttributes *(^mock)(NSString *, NAVTransitionBuilder *) = ^(NSString *path, NAVTransitionBuilder *builder) {
        NAVTransition *transition = builder.build(URL(path));
        return transition.attributes;
    };
    
    it(@"should have a source", ^{
        NAVURL *source = URL(nil);
        
        NAVAttributes *attributes = mock(nil, NAVTransition.builder);
        
        expect(attributes.source).to.equal(source);
        expect(attributes.destination).toNot.beNil();
    });
    
    it(@"should apply transforms", ^{
        NAVURL *destination = URL(@"tests/are/cool?right=1");
        
        NAVAttributes *attributes = mock(@"tests", NAVTransition.builder
            .transform(^(NAVURL *url) { return [url push:@"are"]; })
            .transform(^(NAVURL *url) { return [url push:@"cool"]; })
            .transform(^(NAVURL *url) { return [url updateParameter:@"right" withOptions:NAVParameterOptionsVisible]; }));
       
        expect(attributes.destination.string).to.equal(destination.string);
    });
    
    it(@"should add user objects", ^{
        id object = @9999;
       
        NAVAttributes *attributes = mock(nil, NAVTransition.builder
            .object(object));
        
        expect(attributes.userObject).to.equal(object);
    });
   
    it(@"should add handlers", ^{
        NAVTestHandler handler = ^{
            return @"Let's hope this works!";
        };
        
        NAVAttributes *attributes = mock(nil, NAVTransition.builder
             .handler(handler));
        
        expect(attributes.handler).to.equal(handler);
    });
    
    it(@"should extract component data", ^{
        NSString *data = @"he134a$*0asdjJA098*23j";
        NSString *component = [NSString stringWithFormat:@"test1::%@", data];
        
        NAVAttributes *attributes = mock(nil, NAVTransition.builder
            .transform(^(NAVURL *url) { return [url push:component]; }));
        
        expect(attributes.data).to.equal(data);
    });
    
    it(@"should push components", ^{
        NSString *component = @"yeah";
        
        NAVAttributes *attributes = mock(nil, NAVTransition.builder
            .push(component));
        
        expect(attributes.destination.lastComponent.key).to.equal(component);
    });

    it(@"should pop components", ^{
        NAVAttributes *attributes = mock(@"test", NAVTransition.builder
            .pop(1));
        
        expect(attributes.destination.components.count).to.equal(0);
    });
    
    it(@"should update parameters", ^{
        NSString *parameter = @"whoa";
        NAVParameterOptions options = NAVParameterOptionsVisible;
        
        NAVAttributes *attributes = mock(nil, NAVTransition.builder
            .parameter(@"whoa", NAVParameterOptionsVisible));
        
        expect(attributes.destination[parameter].options).to.equal(options);
    });
    
    it(@"should present parameters", ^{
        NSString *parameter = @"neat";
       
        NAVAttributes *attributes = mock(nil, NAVTransition.builder
            .present(parameter));
        
        expect(attributes.destination[parameter].options).to.equal(NAVParameterOptionsVisible);
    });
    
    it(@"should dismiss parameters", ^{
        NSString *parameter = @"cool";
        
        NAVAttributes *attributes = mock(@"test?cool=1", NAVTransition.builder
            .dismiss(parameter));
        
        expect(attributes.destination[parameter].options).to.equal(NAVParameterOptionsHidden);
    });

});

SpecEnd
