//
//  BTStartView.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/29/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTStartView.h"

@implementation BTStartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.delegate didReceiveTouchAtTime:[[touches anyObject] timestamp] from:0];
    [self drawRed];
    
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.delegate didStopTouchAtTime:[[touches anyObject] timestamp]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
