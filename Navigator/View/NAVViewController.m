//
//  NAVViewController.m
//  Navigator
//

#import "NAVViewController.h"
#import "NAVViewControllerFactory_Private.h"
#import "NAVRouterUtilities.h"

@implementation NAVViewController

+ (void)initialize
{
    [super initialize];
    [NAVViewControllerFactory prepareToLaunch];
}

+ (instancetype)instance
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:self.storyboardName bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:self.storyboardIdentifier];
}

- (void)updateWithAttributes:(NAVAttributes *)attributes
{
    
}

+ (NSString *)storyboardIdentifier
{
    return NSStringFromClass(self);
}

+ (NSString *)storyboardName
{
    NAVAssert(false, NAVExceptionViewConfiguration, @"NAVViewController must specify a storyboard name");
    return nil;
}

@end

NSString * const NAVExceptionViewConfiguration = @"router.view.configuration.exception";
