//
//  BTMoleWhackViewer.h
//  BrainTracker
//
//  Created by Richard Sprague on 4/4/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
// Needed by BTSessionVC : the viewer for a Whack-a-mole UI.


#import <UIKit/UIKit.h>

#import "BTTouchReturnedProtocol.h"
#import "BTStartView.h"
@class BTStimulus;


@interface BTMoleWhackViewer : UIView

@property (strong, nonatomic) NSArray *moles;  // each mole is a potential stimulus. this array contains all possible stimulii

@property (strong,nonatomic) BTStartView *startButton;

- (void) makeStartButton ;

- (void) layOutStimuli;  // designed to be overridden by a subclass

- (void) presentNewStimulusResponse;

- (void) presentForeperiod;

- (void) changeStartButtonLabelTo: (NSString*) newLabel;

- (id)initWithFrame:(CGRect)frame stimulus: (BTStimulus *) stimulus;


- (void) clearAllResponses;

@property (strong, nonatomic) id<BTTouchReturned> motherViewer; // the VC in which this viewer is currently embedded.
@end
