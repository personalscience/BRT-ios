//
//  BTTimer.h
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTimer : NSObject;

@property (strong, nonatomic) NSDate *startTime;

//- (NSTimeInterval *) secondsSinceStart;
- (NSTimeInterval) elapsedTime;
- (NSDate *) startTimer;


@end
