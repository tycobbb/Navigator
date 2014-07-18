//
//  NAVTransaction.h
//  Created by Ty Cobb on 7/15/14.
//

#import "NAVAttributes.h"
#import "NSURL+NAVRouter.h"

@interface NAVTransaction : NSObject

@property (strong, nonatomic, readonly) NAVAttributes *attributes;
@property (assign, nonatomic, readonly) NAVURLType URLType;

@property (copy  , nonatomic, readonly) NSArray *parametersToEnable;
@property (copy  , nonatomic, readonly) NSArray *parametersToDisable;

@property (assign, nonatomic) BOOL isAnimated;
@property (copy  , nonatomic) NSArray *updates;
@property (copy  , nonatomic) void(^completion)(void);

- (instancetype)initWithAttributes:(NAVAttributes *)attributes scheme:(NSString *)scheme;

@end
