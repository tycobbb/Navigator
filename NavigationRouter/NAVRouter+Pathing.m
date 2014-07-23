//
//  NAVRouter+Pathing.m
//  Created by Ty Cobb on 7/23/14.
//

#import "NAVRouter+Pathing.h"

@implementation NAVRouter (Pathing)

- (void)transitionToPath:(NSString *)path withModel:(id)model
{
    NAVAttributes *attributes = [[self.attributesBuilder toPath:path] withModel:model].build;
    [self transitionWithAttributes:attributes animated:YES completion:nil];
}

- (void)transitionToRoot:(NSString *)path
{
    NSString *absolutePath = [NSString stringWithFormat:@"%@://%@", self.scheme, path];
    NAVAttributes *attributes = [self.attributesBuilder toPath:absolutePath].build;
    [self transitionWithAttributes:attributes animated:YES completion:nil];
}

- (void)transitionBack
{
    NAVAttributes *attributes = [self.attributesBuilder popBack:1].build;
    [self transitionWithAttributes:attributes animated:YES completion:nil];
}

@end
