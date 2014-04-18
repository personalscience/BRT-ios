//
//  BTStartVC.h
//  BrainTracker
//
//  Created by Richard Sprague on 3/22/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
// This ViewController is used for the "Wedges" UI
// [see  BTWedgeView.h

/*
 
 The act of instantiating a WedgeView (which happens automatically thanks to the outlet in the storyboard) produces the multicolor fan of wedges as part of the embedded view.  The wedge view doesn't get created in the viewDidLoad --
 
 Anytime a finger touches the screen (technically, whenever a touch is registered on the view controller screen, which is of course the superview of the WedgeView) we look through all of the wedges that are embedded in the WedgeView. If the finger location matches the location of that wedge, then we pass control over to one of the two methods for handling screen presses:
 
 - (void) startPressedAtTime: (NSTimeInterval) time
 
 - (void) responsePressed: (NSString *) responseString atTime: (NSTimeInterval) time
 
 
 
 
 */


#import <UIKit/UIKit.h>

@interface BTStartVC : UIViewController

@end
