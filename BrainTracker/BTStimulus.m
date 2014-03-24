//
//  BTStimulus.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTStimulus.h"


@implementation BTStimulus


- (uint) newStimulus {
    
    self.displayNumber = (arc4random() % TOTAL_STIMULI ) ;  // a number from 1 to n-1
    
    return self.displayNumber;
}

- (BOOL) matchesStimulus: (BTResponse *) response {
    
    if ([response.response[KEY_RESPONSE_STRING] intValue] == self.displayNumber)
        return YES;
    else return NO;
    
    
}

- (id) init
{
    self = [super init];
    
//    self.displayNumber = (arc4random() % 3) + 1;  // a number from 1 to 3
    
    return self;
}

@end
