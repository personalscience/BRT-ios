//
//  BTStimulus.h
//  BrainTracker
//
//  Created by Richard Sprague on 4/6/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//




#import "BTResponse.h"

@interface BTStimulus : BTResponse

- (BOOL) matchesStimulus: (BTResponse *) response;


@property (strong, nonatomic) NSDictionary * stimulus;
@end
