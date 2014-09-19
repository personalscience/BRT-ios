//
//  BTStimulus.h
//  BrainTracker
//
//  Created by Richard Sprague on 4/6/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//




#import "BTResponse.h"  // includes constants. TODO: you should combine the classes BTStimulus and BTResponse

@interface BTStimulus : BTResponse

- (BOOL) matchesStimulus: (BTResponse *) response;

- (int) valueAsInt; // integer representation of the stimulus string;

@property (strong, nonatomic) NSDictionary * stimulus;
@end
