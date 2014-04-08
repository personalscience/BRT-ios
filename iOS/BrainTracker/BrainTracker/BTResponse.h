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
 
 In initial drafts, the response we care about is an NSString respresentation of a button the user pressed.
 
 KEY_RESPONSE_STRING
 
 
 
 
 A BTResponse contains a dict, response, with at least these keys:
 
 KEY_RESPONSE_TIME
 KEY_RESPONSE_STRING
 

 A response can also include additional information:
 * location
 
*/

#define KEY_RESPONSE_TIME @"responseTime"
#define KEY_RESPONSE_STRING @"responseString"
#define KEY_RESPONSE_DATE @"responseDate"

#import <Foundation/Foundation.h>

@interface BTResponse : NSObject
- (BOOL) matchesResponse: (NSString *) response;
- (id) initWithString: (NSString *) initString;
//

//- (void) setResponseTime: (NSTimeInterval) timeInSeconds;

@property NSTimeInterval responseTime;
@property (strong, nonatomic) NSDictionary * response;

//- (NSTimeInterval) responseTime;
//- (NSDictionary *) response;

@end
