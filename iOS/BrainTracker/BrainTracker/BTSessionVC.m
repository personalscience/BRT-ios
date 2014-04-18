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
@property (weak, nonatomic) IBOutlet UILabel *lastTrialStatus;

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
    
   
    if([currentTrialNumber compare:MaxTrialsPerSession]==NSOrderedDescending){
        NSLog(@"currentTrialNumber=%@ exceeds max allowed=%@",[currentTrialNumber description],[MaxTrialsPerSession description]);
        self.BTSessionScoreLabel.text = [[NSString alloc] initWithFormat:@"Session Score = %0.3f",rollingResponsePercentile];
    } else {
    
    if ([response isStimulus]){
        

        [self displayTrialNumber];
        currentTrialNumber = [NSNumber numberWithInt:([currentTrialNumber intValue]+1)];
        [self.trialView presentNewResponses];
      //  [self.trialView presentNewStimulusResponse];
        
    } else {
        
        
        
        response.responseTime = time-prevTime;
        
        // get the all-time percentile for this response and cummulatively add it.
        [self.results saveResult:response];  // save the result first, or you risk crashing when you calculate percentileOfResponse
        
        double responsePercentile = [self.results percentileOfResponse:response]; 
        rollingResponsePercentile = responsePercentile + rollingResponsePercentile/[MaxTrialsPerSession doubleValue];
        
        // add it from a rolling mean
        [self displayTrialNumber];
        self.lastTrialStatus.text = [[NSString alloc] initWithFormat:@"Prev:%0.0fmSec (%0.2f%%)",(time-prevTime)*1000,responsePercentile*100];
        
        
    }
    }
}


// this is only called when the Start Button is released.

- (void) didStopTouchAtTime:(NSTimeInterval)time {
    
  

    if ([currentTrialNumber compare:MaxTrialsPerSession]==NSOrderedSame) {
              self.BTSessionScoreLabel.text = [[NSString alloc] initWithFormat:@"Session Mean: %0.3f%%",rollingResponsePercentile*100];
    } else {
     
        // increment the currentTrialNumber

    prevTime = time;
    
    // load up a randomly-selected mole
    
    [self.trialView presentNewStimulusResponse];
    }
    
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
    
    if ([currentTrialNumber intValue]==0){
        self.BTSessionScoreLabel.text = [[NSString alloc] initWithFormat:@"Begin"];
    } else {
    self.BTSessionScoreLabel.text = [[NSString alloc]initWithFormat:@"Trial %d of %d",[currentTrialNumber intValue],[MaxTrialsPerSession intValue]];
    }

    
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
        [[NSUserDefaults standardUserDefaults] setObject:MaxTrialsPerSession forKey:kBTMaxTrialsPerSessionKey];
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
