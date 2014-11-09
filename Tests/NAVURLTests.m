//
//  NAVURLTests.m
//  Created by Ty Cobb on 7/18/14.
//

SpecBegin(NAVURLTest)

describe(@"URL", ^{
    
    //
    // Construction
    //

    it(@"should have a scheme", ^{
        expect(URL(@"rocket://").scheme).to.equal(NAVTest.scheme);
        expect(URL(@"rocket://test").scheme).to.equal(@"rocket");
    });
    
    it(@"shouldn't create URLs without schemes", ^{
        expect(^{ URL(@""); }).to.raise(NAVExceptionMalformedUrl);
    });
    
    it(@"shouldn't allow components with excess data strings", ^{
        expect(^{ URL(@"rocket://test1::1234::5678"); }).to.raise(NAVExceptionMalformedUrl);
    });
    
    it(@"should have components", ^{
        expect(URL(@"rocket://test").components.count).to.equal(1);
        expect(URL(@"rocket://test1/test2").components.count).to.equal(2);
    });
    
    it(@"should assosciate data to components", ^{
        NAVURL *url = URL(@"rocket://test::1234");
        NAVURLComponent *component = url.components[0];
        
        expect(component.data).toNot.beNil();
        expect(component.data).to.equal(@"1234");
    });
    
    it(@"should allow visible key-value parameters", ^{
        NSArray *urls = URLs(@[
            @"rocket://test?param=1",
            @"rocket://?param=1",
        ]);
        
        for(NAVURL *url in urls) {
            NAVURLParameter *parameter = url.parameters[@"param"];
            expect(parameter).toNot.beNil();
            expect(parameter.options).to.equal(NAVParameterOptionsVisible);
        }
    });
    
    it(@"should render parameter values as strings", ^{
        NSDictionary *urls = @{
            URL(@"rocket://test?param=")  : NSNull.null,
            URL(@"rocket://test?param=1") : @"v",
            URL(@"rocket://test?param=3") : @"vu",
            URL(@"rocket://test?param=5") : @"va",
        };
        
        for(NAVURL *url in urls) {
            NAVURLParameter *parameter = url.parameters[@"param"];
            NSString *value = urls[url] == (id)NSNull.null ? nil : urls[url];
            expect(parameter.value).to.equal(value);
        }
    });
    
    //
    // Mutation
    //
    
    it(@"should push components", ^{
        NAVURL *url = [URL(@"rocket://test?param=1") push:@"test2"];
        expect(url.components.count).to.equal(2);
        expect(url.lastComponent.key).to.equal(@"test2");
    });
    
    it(@"should throw an exception trying to push a nil component", ^{
        expect(^{ [URL(@"rocket://test?param=1") push:nil]; }).to.raise(NAVExceptionIllegalUrlMutation);
    });
    
    it(@"should pop components", ^{
        NAVURL *url = URL(@"rocket://test1/test2/test3?param=1");
        
        url = [url pop:1];
        expect(url.components.count).to.equal(2);
        url = [url pop:2];
        expect(url.components.count).to.equal(0);
        
        expect(NO).to.beTruthy();
    });
    
    it(@"should throw an exception if there aren't enough components to pop", ^{
        expect(^{ [URL(@"rocket://") pop:1]; }).to.raise(NAVExceptionIllegalUrlMutation);
    });
    
    it(@"should update parameters", ^{
        NSDictionary *updates = @{
            @"param"  : @(NAVParameterOptionsVisible | NAVParameterOptionsAsync),
            @"param1" : @(NAVParameterOptionsVisible)
        };
        
        NAVURL *url = URL(@"rocket://test1?param=1");
        for(NSString *name in updates) {
            NAVParameterOptions options = [updates[name] integerValue];
            url = [url updateParameter:name withOptions:options];
            
            NAVURLParameter *parameter = url[name];
            expect(parameter.key).to.equal(name);
            expect(parameter.options).to.equal(options);
        }
    });
    
    it(@"should remove hidden parameters", ^{
        expect(NO).to.beTruthy();
    });
    
    //
    // Serialization
    //
    
    it(@"should serialize to a url", ^{
        expect(NO).to.beTruthy();
    });
    
    it(@"should serialize to a string", ^{
        expect(NO).to.beTruthy();
    });
    
});

SpecEnd
