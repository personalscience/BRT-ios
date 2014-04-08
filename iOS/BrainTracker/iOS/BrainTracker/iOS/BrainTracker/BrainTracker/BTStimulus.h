//
//  BTStimulus.h
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TOTAL_STIMULI 7

#import "BTResponse.h"

@interface BTStimulus : NSObject

@property uint displayNumber;

- (uint) newStimulus;
- (BOOL) matchesStimulus: (BTResponse *) response;

@end
