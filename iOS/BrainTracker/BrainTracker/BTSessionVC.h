//
//  BTSessionVC.h
//  BrainTracker
//
//  Created by Richard Sprague on 4/4/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
// This is the score keeping view controller.
// Embed an instance of a trial view, and this controller will operate the trial.

// This controller knows only that there is a session happening,
// that it will last kMaxTrialTrialsPerSession times,
// each trial has a Stimulus and a Response
// This controller has no idea what sort of thing is being tested, though.
// It doesn't care -- that all happens in the embedded view... (e.g. MoleWhackViewer)


// The basic design is such that you could swap out any type of test for another
// Even if it's a test about, say, hearing some audio and speaking a response, you shouldn't have to modify this VC.




#import <UIKit/UIKit.h>
#import "BTTouchReturnedProtocol.h"

@interface BTSessionVC : UIViewController

@end
