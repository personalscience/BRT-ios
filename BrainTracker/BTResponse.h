//
//  BTResponse.h
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
/*
 
 A response is extremely general purpose:  The underlying data structure could be any of these:
 * string representing a key that the user touched.
* a sound the user spoke
 * an acceleration indictator of some kind
 * GPS coordinates.
 * whatever.
 
 The way you tell if the response matched a stimulus is to call the method
 - (BOOL) matchesStimulus: (BTStimulus *) stimulus
 
 Let this method figure out whether it matched or not, based on whatever logic it wants, such as whether a particular key in the stimulus exists on the response object -- and whether they match.
 
 
 
 A BTResponse may include additional information:
 * location
 
 It can also be used to store Session information [perhaps the class should be renamed, or refactored as a category]
 
 but it always contains the NSDictionary *response , with at least the following three keys (defined in BTResponse.m):
 
*/

extern NSString * const kBTtrialResponseStringKey; // or more precisely, the responseLabel
extern NSString * const kBTtrialLatencyKey;
extern NSString * const kBTtrialTimestampKey;

//#define KEY_RESPONSE_TIME @"responseTime"
//#define KEY_RESPONSE_STRING @"responseString"
//#define KEY_RESPONSE_DATE @"responseDate"

#import <Foundation/Foundation.h>

@interface BTResponse : NSObject
- (BOOL) matchesResponse: (BTResponse *) response;
- (BOOL) isStimulus; // HACK: should be cleaned up later. Used to determine when something is the start button.
- (id) initWithString: (NSString *) initString;



@property NSTimeInterval responseLatency;
@property (strong, nonatomic) NSString *responseLabel;
@property (strong, nonatomic) NSDictionary * response;
@property (strong, nonatomic) NSNumber *idNum;

//@property (nonatomic, retain) NSDate * sessionDate;
//@property (nonatomic, retain) NSString * sessionComment;
//@property (nonatomic, retain) NSNumber * sessionScore;
//@property (nonatomic, retain) NSNumber * sessionRounds;


@end
