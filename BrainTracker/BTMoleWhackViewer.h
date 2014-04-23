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

@interface BTMoleWhackViewer : UIView

- (void) makeStartButton ;

- (void) presentNewStimulusResponse;
- (void) changeStartButtonLabelTo: (NSString*) newLabel;


- (void) clearAllResponses;

@property (strong, nonatomic) id<BTTouchReturned> motherViewer; // the VC in which this viewer is currently embedded.
@end
