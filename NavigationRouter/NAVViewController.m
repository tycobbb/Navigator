//
//  NAVViewController.m
//  NavigationRouter
//

#import "NAVViewController.h"

@implementation NAVViewController

+ (instancetype)instance
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:self.storyboardName bundle:[NSBundle mainBundle]];
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
    [[NSException exceptionWithName:@"router.no.storyboard.name"
                             reason:@"NAVViewController subclasses must specify a storyboard name"
                           userInfo:nil] raise];
    
    return nil;
}

@end
