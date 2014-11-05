//
//  NAVTransaction.h
//  Created by Ty Cobb on 7/15/14.
//

#import "NAVAttributes.h"
#import "NAVURL_legacy.h"

@interface NAVTransaction : NSObject

@property (strong, nonatomic, readonly) NAVAttributes *attributes;
@property (strong, nonatomic, readonly) NAVURL_legacy *sourceURL;
@property (strong, nonatomic, readonly) NAVURL_legacy *destinationURL;

@property (assign, nonatomic) BOOL isAnimated;
@property (strong, nonatomic) NSArray *updates;
@property (copy  , nonatomic) void(^completion)(void);

- (instancetype)initWithAttributes:(NAVAttributes *)attributes scheme:(NSString *)scheme;

@end
