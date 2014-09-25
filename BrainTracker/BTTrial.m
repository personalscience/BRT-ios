//
//  BTTrial.m
//  BrainTracker
//
//  Created by Richard Sprague on 9/20/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTTrial.h"
#import "BTResponse.h"
#import "BTSession.h"

@implementation BTTrial

- (void) setSession: (BTSession *) session {
    
    if (!_trialSession){
        _trialSession = session;
        _trialSessionID = session.sessionID;
    } else
    {NSLog(@"attempting to set a session when one already exists (BTTrial)");
    }
}

- (void) setResponseString: (BTResponse *) response {
    if (!_trialResponseString){
        _trialResponseString = response.responseLabel;
        _trialStimulusString = [[NSString alloc] initWithString:_trialResponseString]; // stimulus=response in the whackamole implementation.
        
        
    } else
    {NSLog(@"attempting to set a responseLabel when one already exists (BTTrial)");
    }
    
}

- (id) init {
    
    self = [super init];
    _trialTimeStamp = [NSDate date];
  //  NSString *timestampMe = [[[NSDateFormatter alloc] init] stringFromDate:_trialTimeStamp];
    
//    _trialSessionID =[[NSString alloc] initWithFormat:@"A%f", [NSDate timeIntervalSinceReferenceDate]] ;
    
 //   _trialStimulusString = [[NSString alloc] initWithString:_trialResponseString]; // stimulus=response in the whackamole implementation.
    
    
    
    return  self;
    
    
}

- (id) initWithResponse: (BTResponse *) response {
    
    self = [self init];
    
    
    [self setResponseString:response];

    // initialize the BTTrial instance variables
//    _trialResponseString = response.responseLabel;
  
    return self;
    
}


@end
