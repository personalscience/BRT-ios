//
//  BTStimulusCollection.m
//  BrainTracker
//
//  Created by Richard Sprague on 9/18/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTStimulusCollection.h"

@implementation BTStimulusCollection
@synthesize stimuliArray;

- (void) addStimulus:(BTStimulus *)stimulus {
    
    [self.stimuliArray addObject:stimulus ];
}

- (id) init {
    
    self = [super init];
    //the first element of the array is reserved for the start button
    self.stimuliArray = [[NSMutableArray alloc] initWithObjects:[[NSString alloc] initWithFormat:@"first string" ], nil];
    
    return self;
    
}


@end
