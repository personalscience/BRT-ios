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
 
 but it always contains a dict, response, with at least the following three keys:
 
*/

extern NSString * const kBTResponseStringKey; // or more precisely, the responseLabel
extern NSString * const kBTResponseTimeKey;
extern NSString * const kBTResponseDateKey;

//#define KEY_RESPONSE_TIME @"responseTime"
//#define KEY_RESPONSE_STRING @"responseString"
//#define KEY_RESPONSE_DATE @"responseDate"

#import <Foundation/Foundation.h>

@interface BTResponse : NSObject
- (BOOL) matchesResponse: (BTResponse *) response;
- (BOOL) isStimulus;
- (id) initWithString: (NSString *) initString;



@property NSTimeInterval responseTime;
@property (strong, nonatomic) NSString *responseLabel;
@property (strong, nonatomic) NSDictionary * response;
@property (strong, nonatomic) NSNumber *idNum;



@end
