//
//  BTResultsTracker.h
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
/*
 
 An instance of this class helps shield you from details of how the full database works. 
 
 A new instance is created for each session.
 
 
 
*/

#define KEY_FOR_RESPONSES @"BTResponses"

// values set in BTResponse.m

extern NSString * const kBTtrialResponseStringKey;
extern NSString * const kBTtrialLatencyKey;
extern NSString * const kBTtrialTimestampKey;



extern NSTimeInterval kBTLatencyCutOffValue;

extern int const kBTlastNTrialsCutoffValue;


#import <Foundation/Foundation.h>

@class BTResponse;
@class BTSession;
@class BTTrial;



@interface BTResultsTracker : NSObject

//- (void) saveResult: (BTResponse *) response;
- (void) saveTrial: (BTTrial *) trial;
- (void) saveSession: (BTSession *) session;
- (double) percentileOfResponse: (BTResponse *) response;
//- (BOOL) isUnderCutOff: (NSTimeInterval)  responseLatency;



@end
