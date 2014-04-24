//
//  BTStimulusResponseView.h
//  BrainTracker
//
//  Created by Richard Sprague on 3/24/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
//  A general-purpose class that can present a button-like object on the screen
//  The object can return its touched status through the TouchReturned protocol
//  Subclass this to make a stimulus-specific object, or a response-specific object.

// This viewer exist to show the contents of a stimulus or response.
// You rarely use this class, but rather, you use its subclasses: BTResponseView or BTStartView


#import <UIKit/UIKit.h>

#import "BTTouchReturnedProtocol.h" // defines the TouchReturned prototocol

#import "BTResponse.h"


@interface BTStimulusResponseView : UIView

- (id) initWithFrame:(CGRect)frame forResponse: (BTResponse *) response;
- (void) drawGreen;
- (void) drawRed;
- (void) drawColor: (UIColor *) newColor;
- (void) animatePresenceWithBlink;
//- (void) animatePresenceAndStay;
//- (void) showLabels;

@property (strong, nonatomic) NSNumber * idNum;
@property (strong , nonatomic) UILabel * label;
@property BTResponse *response;

@end

