//
//  NAVUpdateBuilder.h
//  NavigationRouter
//

@import Foundation;
@import UIKit;

#import "NAVUpdate.h"
#import "NAVRoute.h"
#import "NAVURL.h"

@protocol NAVUpdateBuilderDelegate;

@interface NAVUpdateBuilder : NSObject
@property (weak, nonatomic) id<NAVUpdateBuilderDelegate> delegate;
@end

@protocol NAVUpdateBuilderDelegate <NSObject>

@end
