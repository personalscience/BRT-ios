//
//  BTStimulus.m
//  BrainTracker
//
//  Created by Richard Sprague on 4/6/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTGlobals.h"
#import "BTStimulus.h"


@interface BTStimulus()

@property (nonatomic, strong) NSString * stimulusString;

@end

@implementation BTStimulus

- (BOOL) matchesStimulus: (BTResponse *) response {
    // more code needed here...
    
    
    return YES;
    
}

- (int) valueAsInt {  // the Stimulus is always a string representation of an integer, so this method just returns the int;
    
    NSString *stimulusVal = self.stimulus[kBTtrialResponseStringKey];
    
    NSNumber *val =[[NSNumberFormatter alloc] numberFromString:stimulusVal];

    
    return [val intValue];
    
}


- (id) initWithString: (NSString *) initString {
    
    self = [super init];
    
    
    _stimulus = [[NSMutableDictionary alloc] initWithObjectsAndKeys:initString,kBTtrialResponseStringKey, nil];
    
    
    return  self;
    
    
}

- (id) init {
    
    self = [super init];
    
    int stimulusVal = (arc4random() % (kBTNumberOfStimuli))+1;
    
    NSNumber *val = [[NSNumber alloc] initWithInt:stimulusVal ];
    
    NSString *valString = [[NSNumberFormatter alloc] stringFromNumber:val];
    _stimulus =[[NSMutableDictionary alloc] initWithObjectsAndKeys:valString,kBTtrialResponseStringKey, nil];
    
    // the stimulus is the randomMole index in the self.moles array ]
   // int randomMole = (arc4random() % ([self.moles count]-1))+1 ; // ignore the first mole (which is really just the start button)
    
    return self;
}


@end
