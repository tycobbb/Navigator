//
//  NAVRouter+Pathing.m
//  Created by Ty Cobb on 7/23/14.
//

#import "NAVRouter+Pathing.h"

@implementation NAVRouter (Pathing)

# pragma mark - Path Components

- (void)transitionToPath:(NSString *)path
{
    [self transitionToPath:path withModel:nil];
}

- (void)transitionToPath:(NSString *)path withModel:(id)model
{
    NAVAttributes *attributes = self.attributesBuilder.to(path).with.model(model).build;
    [self transitionWithAttributes:attributes animated:YES completion:nil];
}

- (void)transitionToRoot:(NSString *)path
{
    NSString *absolutePath = [NSString stringWithFormat:@"%@://%@", self.scheme, path];
    NAVAttributes *attributes = self.attributesBuilder.to(absolutePath).build;
    [self transitionWithAttributes:attributes animated:YES completion:nil];
}

- (void)transitionBack
{
    NAVAttributes *attributes = self.attributesBuilder.pop(1).build;
    [self transitionWithAttributes:attributes animated:YES completion:nil];
}

# pragma mark - Parameters

- (void)presentScreen:(NSString *)screen animated:(BOOL)animated
{
    [self presentScreen:screen animated:animated withModel:nil];
}

- (void)presentScreen:(NSString *)screen animated:(BOOL)animated withModel:(id)model
{
    NAVParameterOptions options = NAVParameterOptionsVisible;
    if(!animated)
        options |= NAVParameterOptionsUnanimated;
    [self updateParameter:screen withOptions:options model:model];
}

- (void)dismissScreen:(NSString *)screen animated:(BOOL)animated
{
    NAVParameterOptions options = NAVParameterOptionsHidden;
    if(!animated)
        options |= NAVParameterOptionsUnanimated;
    [self updateParameter:screen withOptions:options model:nil];
}

- (void)updateParameter:(NSString *)parameter withOptions:(NAVParameterOptions)options model:(id)model
{
    NAVAttributes *attributes = self.attributesBuilder.parameter(parameter, options).model(model).build;
    [self transitionWithAttributes:attributes animated:YES completion:nil];
}

@end
