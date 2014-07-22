//
//  NAVAttributes.h
//  Created by Ty Cobb on 7/14/14.
//

@import Foundation;

@interface NAVAttributes : NSObject
@property (copy  , nonatomic) NSURL *sourceURL;
@property (copy  , nonatomic) NSURL *destinationURL;
@property (strong, nonatomic) id model;
@end
