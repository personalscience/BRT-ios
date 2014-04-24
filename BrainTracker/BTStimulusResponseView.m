//
//  BTStimulusResponseView.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/24/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTStimulusResponseView.h"



@interface BTStimulusResponseView()

@property (strong, nonatomic) UIColor *buttonColor;

//@property (strong,nonatomic) NSAttributedString *labelForView;

@end



@implementation BTStimulusResponseView

{
    CGPoint previousLocation;
  //  uint idNum;
}


#pragma mark Setters/Getters


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
  //  self.alpha=1.0;
    
    [self setNeedsDisplay]; //update the new color right away
    
}
- (UIBezierPath *) circleButton {
    
    UIBezierPath *cPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    
    
    return cPath;
    
}




- (UIImage *)createImage
{
	UIColor *color = [self buttonColor];
    
	
    
	UIGraphicsBeginImageContext(self.bounds.size);
    
	// Create a filled ellipse
	[color setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [path fill];
    [self showLabels];
	
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}


//#pragma mark Touch Handling
//- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
//{
//	CGPoint translation = [gestureRecognizer translationInView:self.superview];
//	CGPoint newcenter = CGPointMake(previousLocation.x + translation.x, previousLocation.y + translation.y);
//	
//	// Bound movement into parent bounds
//	float halfx = CGRectGetMidX(self.bounds);
//	newcenter.x = MAX(halfx, newcenter.x);
//	newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
//	
//	float halfy = CGRectGetMidY(self.bounds);
//	newcenter.y = MAX(halfy, newcenter.y);
//	newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
//	
//	// Set new location
//	self.center = newcenter;
//}



- (NSAttributedString*) attributedStringOfIdNum {
    
    NSString *numLabelString = [[NSString alloc] initWithFormat:@"%d",[self.idNum intValue]];
    NSMutableAttributedString *numLabel = [[NSMutableAttributedString alloc] initWithString:numLabelString];
    
    
    return numLabel;
}

// show a label on this object, precisely positioned at the center.
- (void) showLabels {
    
    if (self.label) {

    
    float centerX = self.bounds.size.width/2 + self.bounds.origin.x;
    float centerY = self.bounds.size.height/2 + self.bounds.origin.y;
        CGSize stringSize = CGSizeMake(self.label.attributedText.size.width, self.label.attributedText.size.height);

        
          [self.label.attributedText drawInRect:CGRectMake(centerX-stringSize.width/2, centerY-stringSize.height/2, centerX+stringSize.width/2, centerY+stringSize.height/2)];
 //   NSLog(@"drawing %@ at %@",numLabel, NSStringFromCGRect(self.frame));
    } // else NSLog(@"no label here");

    
}

#pragma mark External Instance Methods


// the view goes from fully-on (i.e. alpha=1.0) to completely disappeared (alpha=0.0) in 3 seconds.
- (void) animatePresenceWithBlink {
    
   
    [UIView animateWithDuration:2.0 animations:^{
        [self setAlpha:1.0];
        self.transform = CGAffineTransformMakeScale(0.0, 0.0);

    } completion:^(BOOL finished) {
        [self setAlpha:0.0];
        self.transform = CGAffineTransformIdentity;
    
    }];
    
}

- (void) animatePresenceAndStay {
    
    [UIView animateWithDuration:2.0 animations:^{
        [self setAlpha:1.0];
        self.transform = CGAffineTransformMakeScale(0.0, 0.0);

    } completion:^(BOOL finished) {
        [self setAlpha:1.0];
        self.transform = CGAffineTransformIdentity;
        [self drawRed];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedAnimationForMoleDisappearance" object:self];

    }];
    
}

- (void) drawGreen {
    [self setColor:[UIColor greenColor]];
    
}

- (void) drawRed {
    [self setColor:[UIColor redColor]];
}

- (void) drawColor: (UIColor*) newColor {
    [self setColor:newColor];
}


- (void)drawRect:(CGRect)rect
{
    

//    self.backgroundColor = nil;
 //   self.opaque = NO;

    
    UIImageView *circleImage = [[UIImageView alloc] initWithImage:[self createImage]];
  
   [self addSubview:circleImage];


    [self showLabels];
    
}

#pragma mark Initializers

// the new button will contain a response. Note that a "response" could also be a stimulus.

- (id) initWithFrame:(CGRect)frame {
    NSLog(@"error: initializing BTStimulusResponseView without a response"); 
    return [self initWithFrame:frame forResponse:NULL];
   
    
}

- (id) initWithFrame:(CGRect)frame forResponse: (BTResponse *) response {
    
    self=[super initWithFrame:frame
          ];
    
    self.response = response;
    
    self.idNum = [[[NSNumberFormatter alloc] init] numberFromString:[response responseLabel]];
                  
    self.backgroundColor = nil; // makes background transparent
    self.opaque = NO;
    self.alpha = 1.0; 
    //        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    //    self.gestureRecognizers = @[pan];
    return self;
    
}



@end
