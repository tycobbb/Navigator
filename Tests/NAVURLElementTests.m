//
//  NAVURLElementTests.m
//  Navigator
//

SpecBegin(NAVURLElementTests)

describe(@"a parameter", ^{

    it(@"should render its value properly", ^{
        NSDictionary *optionsMap = @{
           @(NAVParameterOptionsHidden) : NSNull.null,
           @(NAVParameterOptionsVisible) : @"v",
           @(NAVParameterOptionsVisible | NAVParameterOptionsUnanimated) : @"vu",
           @(NAVParameterOptionsVisible | NAVParameterOptionsAsync) : @"va",
        };
        
        for(NSNumber *options in optionsMap) {
            NAVURLParameter *parameter = [[NAVURLParameter alloc] initWithKey:@"p" options:options.integerValue];
            NSString *value = optionsMap[options] == (id)NSNull.null ? nil : optionsMap[options];
            expect(parameter.value).to.equal(value);
        }
    });
    
});

SpecEnd
