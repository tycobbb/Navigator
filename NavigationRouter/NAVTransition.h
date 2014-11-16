//
//  NAVTransition.h
//  NavigationRouter
//

@import Foundation;

#import "NAVAttributes.h"

@interface NAVTransition : NSObject

/**
 @brief The view updates to run for this transition
    
 The updates are stored sequentially, and each update encapsulates the information
 necessary to perform one interface update.
*/

@property (nonatomic, readonly) NSArray *updates;

/**
 @brief Desginated initializer. Creates a new transition with the given attributes.
 
 The attributes at this point should be incomplete--namely, missing a source URL. The
 necessary information to complete the attributes should be passed in @c startWithUrl:.
 
 @param attributes The attributes for the transition to run
 
 @return A new NAVTransition instance for the specified attributes
*/

- (instancetype)initWithAttributes:(NAVAttributes *)attributes;

/**
 @brief Starts the transition, performing its updates
 
 The transition populates its attributes appropriate and then generates and runs a sequence of
 interface updates.
 
 @param url The URL to transition from, which will be used to determine the list of updates
*/

- (void)startWithUrl:(NAVURL *)url;

@end
