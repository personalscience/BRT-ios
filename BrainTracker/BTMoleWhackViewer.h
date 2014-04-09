//
//  BTMoleWhackViewer.h
//  BrainTracker
//
//  Created by Richard Sprague on 4/4/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTouchReturnedProtocol.h"

@interface BTMoleWhackViewer : UIView

- (void) makeStartButton ;

- (void) presentNewStimulusResponse;
- (void) presentNewResponses;

@property (strong, nonatomic) id<BTTouchReturned> motherViewer; // the VC in which this viewer is currently embedded.
@end
