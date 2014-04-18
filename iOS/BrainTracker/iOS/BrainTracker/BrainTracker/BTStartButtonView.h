//
//  BTStartButtonView.h
//  BrainTracker
//
//  Created by Richard Sprague on 3/24/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchReturned <NSObject>

@optional
- (void) didReceiveTouchAtTime: (NSTimeInterval) time from:(uint) idNum ;

@end


@interface BTStartButtonView : UIView

- (id) initWithFrame:(CGRect)frame id: (uint) num;
- (void) drawGreen;
- (void) drawRed;
@property (weak) id <TouchReturned>delegate;

@end

