//
//  BTStartView.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/29/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTStartView.h"

@implementation BTStartView


//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//
//
//    return self;
//}

- (UIBezierPath *) rectButton {
    
    UIBezierPath *cPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [cPath fill];
    
    return cPath;
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
 //   [self.delegate didReceiveTouchAtTime:[[touches anyObject] timestamp] from:0];
    
//    [self.delegate didReceiveResponse:self.response atTime:[[touches anyObject] timestamp]];
    
    
    [self.delegate didPressStartButtonAtTime:[[touches anyObject] timestamp]];
    [self drawRed];

    
}



- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.delegate didStopTouchAtTime:[[touches anyObject] timestamp]];

    [self drawGreen];
}




@end
