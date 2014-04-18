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
//@property uint idNum;



@end



@implementation BTStartButtonView

{
    CGPoint previousLocation;
    uint idNum;
}


- (id) initWithFrame:(CGRect)frame id: (uint) num {
    
    self=[super initWithFrame:frame
          ];
    
    idNum = num;
     self.backgroundColor = [UIColor blueColor];

    return self;
    
}



- (UIImage *)createImage
{
	UIColor *color = [UIColor redColor];
    
	
    
	UIGraphicsBeginImageContext(self.bounds.size);
    
	// Create a filled ellipse
	[color setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [path fill];
	
	
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.delegate didReceiveTouchAtTime:[[touches anyObject] timestamp] from:idNum];
    previousLocation = self.center;
    
}


- (UIColor *) buttonColor {
    
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
    
   // self.layer.contents= [self createImage];
    UIBezierPath *cPath = [self circleButton];
    [self.buttonColor setFill];
    self.backgroundColor = [UIColor grayColor];
    
    [cPath fill];
    
    UIImageView *circleImage = [[UIImageView alloc] initWithImage:[self createImage]];
    
 //   [self addSubview:circleImage];
    
    NSString *numLabelString = [[NSString alloc] initWithFormat:@"%d",idNum];
    NSAttributedString *numLabel = [[NSAttributedString alloc] initWithString:numLabelString];
    
    
    [numLabel drawAtPoint:(CGPoint){floor(self.bounds.size.width/2-5),floor(self.bounds.size.height/2-5)}];
    
}


@end
