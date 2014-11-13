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
    NAVAttributes_legacy *attributes = self.attributesBuilder.to(path).with.model(model).build;
    [self transitionWithAttributes:attributes animated:YES completion:nil];
}

- (void)transitionToRoot:(NSString *)path
{
    NSString *absolutePath = [NSString stringWithFormat:@"%@://%@", self.scheme, path];
    NAVAttributes_legacy *attributes = self.attributesBuilder.to(absolutePath).build;
    [self transitionWithAttributes:attributes animated:YES completion:nil];
}

- (void)transitionBack
{
    NAVAttributes_legacy *attributes = self.attributesBuilder.pop(1).build;
    [self transitionWithAttributes:attributes animated:YES completion:nil];
}

# pragma mark - Parameters

- (void)presentScreen:(NSString *)screen animated:(BOOL)animated
{
    [self presentScreen:screen animated:animated withModel:nil];
}

- (void)presentScreen:(NSString *)screen animated:(BOOL)animated withModel:(id)model
{
    NAVParameterOptions_legacy options = NAVParameterOptions_legacyVisible;
    if(!animated)
        options |= NAVParameterOptions_legacyUnanimated;
    [self updateParameter:screen withOptions:options model:model];
}

- (void)dismissScreen:(NSString *)screen animated:(BOOL)animated
{
    [self dismissScreen:screen animated:animated completion:nil];
}

- (void)dismissScreen:(NSString *)screen animated:(BOOL)animated completion:(void(^)(void))completion
{
    NAVParameterOptions_legacy options = NAVParameterOptions_legacyHidden;
    if(!animated)
        options |= NAVParameterOptions_legacyUnanimated;
    [self updateParameter:screen withOptions:options model:nil completion:completion];
}

- (void)updateParameter:(NSString *)parameter withOptions:(NAVParameterOptions_legacy)options model:(id)model
{
    [self updateParameter:parameter withOptions:options model:model completion:nil];
}

- (void)updateParameter:(NSString *)parameter withOptions:(NAVParameterOptions_legacy)options model:(id)model completion:(void(^)(void))completion
{
    NAVAttributes_legacy *attributes = self.attributesBuilder.parameter(parameter, options).model(model).build;
    [self transitionWithAttributes:attributes animated:YES completion:nil];
}

@end
