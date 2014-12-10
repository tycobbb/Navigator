//
//  NAVTransitionTests.m
//  NavigationRouter
//

#import "NAVTransition.h"

SpecBegin(NAVTransitionTests)

describe(@"the transition", ^{
  
    NAVUpdateBuilder *updateBuilder = [NAVUpdateBuilder new];
    
    NAVTransition *(^transitionTo)(NAVAttributesBuilder *) = ^(NAVAttributesBuilder *builder) {
        NAVTransition *transition = [[NAVTransition alloc] initWithAttributesBuilder:builder];
        [transition startFromUrl:URL(nil) withUpdateBuilder:updateBuilder];
        return transition;
    };
   
    it(@"should require an attributes builder", ^{
        expect(^{ transitionTo(nil); }).to.raise(NSInternalInconsistencyException);
    });
    
    it(@"should support push updates", ^{
        NAVTransition *transition = transitionTo(NAVAttributes.builder
            .push(@"test2")
        );
        
        NAVUpdate *update = transition.updates.firstObject;
        expect(update).toNot.beNil();
        expect(update.type).to.equal(NAVUpdateTypePush);
    });
    
    it(@"should support pop updates", ^{
        NAVTransition *transition = transitionTo(NAVAttributes.builder
            .pop(1)
        );
        
        NAVUpdate *update = transition.updates.firstObject;
        expect(update).toNot.beNil();
        expect(update.type).to.equal(NAVUpdateTypePop);
    });
    
    it(@"should support replace updates", ^{
        NAVTransition *transition = transitionTo(NAVAttributes.builder
            .transform(^(NAVURL *url) {
                return URL([NSString stringWithFormat:@"%@://replace", NAVTest.scheme]);
            })
        );
        
        NAVUpdate *update = transition.updates.firstObject;
        expect(update).toNot.beNil();
        expect(update.type).to.equal(NAVUpdateTypeReplace);
    });
    
    it(@"should support animation updates", ^{
        NAVTransition *transition = transitionTo(NAVAttributes.builder
            .parameter(@"param", NAVParameterOptionsVisible)
        );
        
        NAVUpdate *update = transition.updates.firstObject;
        expect(update).toNot.beNil();
        expect(update.type).to.equal(NAVUpdateTypeAnimation);
    });
    
    it(@"should sequence updates", ^{
        NSArray *types = @[ @(NAVUpdateTypePush), @(NAVUpdateTypePush), @(NAVUpdateTypeAnimation) ];
        
        NAVTransition *transition = transitionTo(NAVAttributes.builder
            .parameter(@"param", NAVParameterOptionsVisible)
            .push(@"push1")
            .push(@"push2")
        );
       
        expect(transition.updates.count).to.equal(types.count);
        types.each(^(NSNumber *type, NSInteger index) {
            NAVUpdate *update = transition.updates[index];
            
            expect(update).toNot.beNil();
            expect(update.type).to.equal(type.integerValue);
        });
    });
    
});

SpecEnd
