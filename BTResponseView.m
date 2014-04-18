//
//  BTResponseView.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTResponseView.h"

@implementation BTResponseView

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
   // [self.delegate didReceiveTouchAtTime:[[touches anyObject] timestamp] from:[self.idNum intValue]];
 //   previousLocation = self.center;
//    self.alpha=0.0;
    [self drawRed];
    [self.delegate didReceiveResponse:self.response atTime:[[touches anyObject] timestamp]];
    
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self drawGreen];
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
- (void)drawRect:(CGRect)rect
{
    [self rectButton];
}
*/

@end
