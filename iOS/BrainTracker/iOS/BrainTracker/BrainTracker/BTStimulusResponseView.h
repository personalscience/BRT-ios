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


#import <UIKit/UIKit.h>

@protocol TouchReturned <NSObject>

@optional
- (void) didReceiveTouchAtTime: (NSTimeInterval) time from:(uint) idNum ;
- (void) didStopTouchAtTime: (NSTimeInterval) time;

@end


@interface BTStimulusResponseView : UIView

- (id) initWithFrame:(CGRect)frame id: (uint) num;
- (void) drawGreen;
- (void) drawRed;
- (void) drawColor: (UIColor *) newColor;
- (void) animatePresence;
@property (weak) id <TouchReturned>delegate;

@end

