//
//  BTTrial.h
//  BrainTracker
//
//  Created by Richard Sprague on 9/20/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTResponse;
@class BTSession;

@interface BTTrial : NSObject

- (id) initWithResponse: (BTResponse *) response;
- (void) setSession: (BTSession *) session;
- (void) setResponseString: (BTResponse *) response;

// transitioning this to a BTTrial class needs these properties
@property (nonatomic, strong) NSDate * trialTimeStamp;
@property (nonatomic, strong) NSString * trialStimulusString;
@property (nonatomic, strong) NSNumber * trialLatency;
@property (nonatomic, strong) NSString * trialSessionID;
@property (nonatomic, strong) NSNumber * trialForeperiod;
@property (nonatomic, strong) NSString * trialResponseString;

@property (nonatomic, strong) NSNumber * trialNumber;
@property (nonatomic, strong) NSNumber * trialInclude;
@property (nonatomic, strong) NSNumber * trialCorrect;

@property (nonatomic, strong) BTSession *trialSession;

@end
