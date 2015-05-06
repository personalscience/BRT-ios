//
//  BTSession.h
//  BrainTracker
//
//  Created by Richard Sprague on 5/24/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
// Note: this stores the same info as BTDataSession.h
// so you better modify this if you modify that.
// TODO: find some way to synthesize these two.

#import <Foundation/Foundation.h>



@interface BTSession : NSObject


@property (nonatomic, retain) NSString * sessionComment;
@property (nonatomic, retain) NSDate * sessionDate;
@property (nonatomic, retain) NSString * sessionID;
@property (nonatomic, retain) NSNumber * sessionScore;  // a percentile, value from 0.0 to 1.0
@property (nonatomic, retain) NSNumber * sessionRounds; // integer number of rounds in this session
- (id) initWithComment: (NSString *) comment;

@end
