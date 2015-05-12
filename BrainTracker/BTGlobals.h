//
//  BTGlobals.h
//  BrainTracker
//
//  Created by Richard Sprague on 12/21/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#ifndef BrainTracker_BTGlobals_h
#define BrainTracker_BTGlobals_h

// #define KEY_FOR_RESPONSES @"BTResponses"

// values set in BTAppDelegate.m
extern NSString *ZBAccessToken;
extern NSString *ZBScopeToken;

// values set in BTSettings.m
extern NSString * const kBTMaxTrialsPerSessionKey;
extern NSString * const kBTPrecisionControlKey;
extern NSString * const kBTLatencyCutOffValueKey;
extern NSString * const kBTZBAccessTokenKey;
extern NSString * const kBTZBScopeTokenKey;
extern NSString * const kBTZBClientIDKey;
extern NSTimeInterval kBTLatencyCutOffValue;
extern uint const kBTNumberOfStimuli;
extern bool kBTPrecisionControl;
extern bool BTuseZB;
typedef enum {BTInterfaceArc,BTInterfaceLines} BTInterfaceSelectionType;
extern BTInterfaceSelectionType BTInterfaceSelection; // choose the type of interface.


// values set in BTResponse.m
extern NSString * const kBTtrialResponseStringKey;
extern NSString * const kBTtrialLatencyKey;
extern NSString * const kBTtrialTimestampKey;


// needed by BTStimulus.m ?
//extern uint const kBTNumberOfStimuli;


//extern NSTimeInterval kBTLatencyCutOffValue;

extern int const kBTlastNTrialsCutoffValue;  // defined in BTResultsTracker.m



#define ZBUSERNAME_KEY @"USERNAME"
#define ZBPASSWORD_KEY @"PASSWORD"
//#define ZBACCESSTOKEN_KEY @"ACCESSTOKEN"
//#define ZBCLIENTID_KEY @"CLIENTID"
// #define ZBSCOPETOKEN_KEY @"ZBSCOPETOKEN"

#endif
