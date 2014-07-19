//
//  NAVURLComponents.h
//  Created by Ty Cobb on 7/18/14.
//

#import "NAVURLComponent.h"
#import "NAVURLParameter.h"

typedef NS_ENUM(SInt32, NAVURLType) {
    NAVURLTypeInternal,
    NAVURLTypeExternal
};

@interface NAVURL : NSURLComponents

@property (assign, nonatomic, readonly) NAVURLType type;
@property (strong, nonatomic, readonly) NAVURLComponent *nav_host;
@property (strong, nonatomic, readonly) NSArray *nav_components;
@property (strong, nonatomic, readonly) NSDictionary *nav_parameters;

+ (instancetype)URLWithURL:(NSURL *)url resolvingAgainstScheme:(NSString *)scheme;

@end
