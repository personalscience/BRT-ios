//
//  BTTouchReturned.h
//  BrainTracker
//
//  Created by Richard Sprague on 4/6/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BTResponse.h"
@class BTResponse;

@protocol BTTouchReturned <NSObject>

@optional
- (void) didReceiveTouchAtTime: (NSTimeInterval) time from:(uint) idNum ;
- (void) didStopTouchAtTime: (NSTimeInterval) time;

- (void) didReceiveResponse: (BTResponse *) response atTime: (NSTimeInterval) time;

- (void) didPressStartButtonAtTime: (NSTimeInterval) time;
- (void) didFinishForeperiod;




@end

