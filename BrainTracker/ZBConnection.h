//
//  ZBConnection.h
//  BrainTracker
//
//  Created by Richard Sprague on 12/12/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZBConnectionProtocol.h"

@interface ZBConnection : NSObject

@property (strong, nonatomic) NSString *ZBAccessTokenString;
@property (strong, nonatomic) NSString *ZBClientIDString;
@property (strong, nonatomic) NSString *ZBScopeTokenString;

- (void) addNewEventToBucket: (NSString *) bucketID withEvent: (NSDictionary *) eventDict;

@property (strong, nonatomic) id delegate;


@end
