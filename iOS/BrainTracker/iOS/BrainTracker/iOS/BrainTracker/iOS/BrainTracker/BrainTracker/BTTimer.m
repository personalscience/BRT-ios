//
//  BTTimer.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTTimer.h"

@implementation BTTimer



- (NSDate *) startTimer {
    
    
    
    self.startTime = [[NSDate alloc] init];

    return self.startTime;
    
}


- (id) init
{
    self = [super init];
    
    self.startTime = [[NSDate alloc] init];
    
    return self;
}

- (NSTimeInterval ) elapsedTime
{
    return [[NSDate date] timeIntervalSinceDate:self.startTime] - 0.0; // subtract a little to make it closer to milliseconds //-[self.startTime timeIntervalSinceNow];
    
}

@end
