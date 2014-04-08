//
//  BTResponseView.h
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTStimulusResponseView.h"

@interface BTResponseView :  BTStimulusResponseView

@property (weak) id <BTTouchReturned>delegate;

@end
