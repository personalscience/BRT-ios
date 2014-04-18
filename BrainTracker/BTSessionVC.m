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

- (BOOL) incrementTrialNumber {
    bool overMax = NO;
    

     currentTrialNumber = [NSNumber numberWithInt:([currentTrialNumber intValue]+1)];
    
    if([currentTrialNumber compare:MaxTrialsPerSession]==NSOrderedDescending){
        overMax = YES;
    }
    
    return overMax;
    
}
- (void) didReceiveResponse:(BTResponse *)response atTime:(NSTimeInterval)time {
    
   
    if([currentTrialNumber compare:MaxTrialsPerSession]==NSOrderedDescending){  // this should never be true, because it should have been caught elsewhere
        NSLog(@"currentTrialNumber=%@ exceeds max allowed=%@",[currentTrialNumber description],[MaxTrialsPerSession description]);
        self.BTSessionScoreLabel.text = [[NSString alloc] initWithFormat:@"Session Score = %0.3f",rollingResponsePercentile];
    } else {
        
        if ([response isStimulus]){ // i.e. you're hitting the 'start' button. Nothing happens except you see a new (random) response
            
            
            [self displayTrialNumber];
            // don't bother incrementing the trial number just yet -- that can wait till you hit a response button
            // Don't do anything else.  The next action will happen when the Stimulus/Start button is released
            // [self.trialView presentNewResponses];
            
            
        } else {  // a Response key has been pressed...
            
            response.responseTime = time-prevTime;
            
            // get the all-time percentile for this response and cummulatively add it.
            [self.results saveResult:response];  // save the result first, or you risk crashing when you calculate percentileOfResponse
            
            double responsePercentile = [self.results percentileOfResponse:response];
            rollingResponsePercentile = rollingResponsePercentile + responsePercentile/[MaxTrialsPerSession doubleValue];
            NSLog(@" percentile = %0.3f RP=%0.3f",responsePercentile, rollingResponsePercentile);
            self.sessionResults = rollingResponsePercentile ;
            
            // add it from a rolling mean
            [self displayTrialNumber];
            self.lastTrialStatus.text = [[NSString alloc] initWithFormat:@"Prev:%0.0fmSec (%0.2f%%)",(time-prevTime)*1000,responsePercentile*100];
            
            [self.trialView clearAllResponses]; // wipe the response key so you can't press it again
            
            if ([self incrementTrialNumber]) { // true if you're over the MaxTrials, so post notification and exit
                [self.results saveSession:self.sessionResults];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"displayResponsePercentile" object:self];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {  // you're not over the Max trials, so no need to do anything special, but note that the currentTrialNumber is now incremented
                [self displayTrialNumber];
               
            }
            
        }
    }
}


// this is only called when the Start Button is released.

- (void) didStopTouchAtTime:(NSTimeInterval)time {
    
  

    if ([currentTrialNumber compare:MaxTrialsPerSession]==NSOrderedDescending) { //i.e. you're over MaxTrials
        
        NSLog(@"Shouldn't happen: over MaxTrials on didStopTouchAtTime.  Check the code to find out why");
        
        self.sessionResults = rollingResponsePercentile * 100 ;
        self.BTSessionScoreLabel.text = [[NSString alloc] initWithFormat:@"Session Mean: %0.3f%%",self.sessionResults];
       
        
        // need code here to go back to unwindSegue
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:@"displayResponsePercentile" object:self];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {


    prevTime = time;  // begin the clock that measures how long it takes to press the Response button
    
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
        self.BTSessionScoreLabel.text = [[NSString alloc] initWithFormat:@"Begin %d Trials",[MaxTrialsPerSession intValue]];
    } else {
    self.BTSessionScoreLabel.text = [[NSString alloc]initWithFormat:@"Press to Start Trial %d of %d",[currentTrialNumber intValue],[MaxTrialsPerSession intValue]];
    }

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MaxTrialsPerSession = [[NSUserDefaults standardUserDefaults] objectForKey:kBTMaxTrialsPerSessionKey];
    currentTrialNumber = @1;
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
