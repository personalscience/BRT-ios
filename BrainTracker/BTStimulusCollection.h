//
//  BTStimulusCollection.h
//  BrainTracker
//
//  Created by Richard Sprague on 9/18/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
// all of the valid stimuli for


#import "BTStimulus.h"

@interface BTStimulusCollection : NSObject

- (void) addStimulus: (BTStimulus *) stimulus;

@property (strong, nonatomic) NSMutableArray * stimuliArray;

@end
