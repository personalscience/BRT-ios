//
//  BTStimulusView.h
//  PlayStimulusPresent
//
//  Created by Richard Sprague on 3/21/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTStimulusView : UIView


- (UIBezierPath *) wedge: (uint) wedgeNumber;

- (UIBezierPath *) circleAtCenterWithRadius: (CGFloat) radius;

@end
