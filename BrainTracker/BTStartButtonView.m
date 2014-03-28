//
//  BTStartButtonView.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/24/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTStartButtonView.h"


@interface BTStartButtonView()

@property (strong, nonatomic) UIColor *buttonColor;

@end



@implementation BTStartButtonView

- (UIColor *) getButtonColor {
    
    UIColor *color = [UIColor greenColor];
    if (!_buttonColor) {
        [self setColor:color];
        
    } else color = _buttonColor;
    
    return color;
    
}
- (void) setColor: (UIColor *) color {
    
    if (!_buttonColor) {
        _buttonColor = [[UIColor alloc] init];
        _buttonColor  = [UIColor greenColor];
    }
    
    self.buttonColor = color;

    [self setNeedsDisplay];
    
}
- (UIBezierPath *) circleButton {
    
    UIBezierPath *cPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
   
    
    return cPath;
    
}

- (void) drawGreen {
    [self setColor:[UIColor greenColor]];
    
}

- (void) drawRed {
    [self setColor:[UIColor redColor]];
}


- (void)drawRect:(CGRect)rect
{
    
    UIBezierPath *cPath = [self circleButton];
    [self.buttonColor setFill];
    
    [cPath fill];
    
    
}


@end
