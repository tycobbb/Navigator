//
//  NAVViewController.m
//  NavigationRouter
//

#import "NAVViewController.h"

@implementation NAVViewController

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
    [NSException raise:NAVExceptionViewConfiguration format:@"NAVViewController must specify a storyboard name"];
    return nil;
}

@end

NSString * const NAVExceptionViewConfiguration = @"router.view.configuration.exception";
