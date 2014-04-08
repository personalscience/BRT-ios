//
//  BTSessionVC.m
//  BrainTracker
//
//  Created by Richard Sprague on 4/4/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTSessionVC.h"
#import "BTMoleWhackViewer.h"
#import "BTResultsTracker.h"

@interface BTSessionVC ()<BTTouchReturned>

@property (weak, nonatomic) IBOutlet UIView *trialViewPlaceHolder;
@property (strong, nonatomic) BTMoleWhackViewer *trialView;

@property (weak, nonatomic) IBOutlet UILabel *BTSessionScoreLabel;

@property (strong, nonatomic) BTResultsTracker *results;

@end
/*
const CGFloat kMoleHeight = 50;
const uint kMoleNumCols = 2;
const uint kMOleNumRows = 3;
const uint kMoleCount = kMOleNumRows * kMoleNumCols;
*/

NSString * const kBTMaxTrialsPerSessionKey;

@implementation BTSessionVC
{
    NSNumber *MaxTrialsPerSession;
    NSNumber *currentTrialNumber;
    double rollingResponsePercentile; // add all the percentiles until
    NSTimeInterval prevTime;
}

- (BTResultsTracker *) results {
    
    if(!_results) {
        _results = [[BTResultsTracker alloc] init];
        self.results = _results;
    }
    return _results;
    
}

- (void) didReceiveResponse:(BTResponse *)response atTime:(NSTimeInterval)time {
    
    
}


- (void) didReceiveTouchAtTime:(NSTimeInterval)time from:(uint)idNum{
    
    if (idNum == 0){
  
        currentTrialNumber = [NSNumber numberWithInt:([currentTrialNumber intValue]+1)];
        if(currentTrialNumber>MaxTrialsPerSession){
            NSLog(@"currentTrialNumber=%@ exceeds max allowed=%@",[currentTrialNumber description],[MaxTrialsPerSession description]);
        }
        [self displayTrialNumber];
        
    } else {
        
        // get the all-time percentile for this response and cummulatively add it.
        
        double responsePercentile = 1.0; // just a placeholder: need a real lookup function for this.
         rollingResponsePercentile = responsePercentile + rollingResponsePercentile/[MaxTrialsPerSession doubleValue];
        
        // add it from a rolling mean
        self.BTSessionScoreLabel.text = [[NSString alloc] initWithFormat:@"Session %% = %0.3f",responsePercentile];
        
        NSTimeInterval duration = time ;
    }
    
    
}


- (void) didStopTouchAtTime:(NSTimeInterval)time {
    

    if (currentTrialNumber == MaxTrialsPerSession) {
              self.BTSessionScoreLabel.text = [[NSString alloc] initWithFormat:@"Session %% = %0.3f",rollingResponsePercentile];
    }
    prevTime = time;
    
}




- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

    [self.trialView setNeedsDisplay];
}

- (void) didRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.trialView setNeedsDisplay];
   
}

- (void) displayTrialNumber {
    self.BTSessionScoreLabel.text = [[NSString alloc]initWithFormat:@"Trial %d of %d",[currentTrialNumber intValue],[MaxTrialsPerSession intValue]];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MaxTrialsPerSession = [[NSUserDefaults standardUserDefaults] objectForKey:kBTMaxTrialsPerSessionKey];
    currentTrialNumber = @0;
    rollingResponsePercentile= 0.0f;
    

    
    if(!MaxTrialsPerSession){
        NSLog(@"No MaxTrialsPerSessionKey found");
        MaxTrialsPerSession = @32;
    }
    self.trialView = [[BTMoleWhackViewer alloc] initWithFrame:self.trialViewPlaceHolder.frame];
    self.trialView.motherViewer = self;
    self.trialView.backgroundColor= [UIColor whiteColor];
    
    [self.trialViewPlaceHolder removeFromSuperview];
    [self.view addSubview:self.trialView];
    [self.trialView makeStartButton];
    [self displayTrialNumber];
}



@end
