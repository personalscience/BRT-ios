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
    
    bool finishedForeperiod;
    bool trialIsCancelled;
    
    NSNotification *didFinishForeperiod;
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
        self.BTSessionScoreLabel.text = [[NSString alloc] initWithFormat:@"Session Score = %0.0f",rollingResponsePercentile];
    } else {
        
        if ([response isStimulus]){ // i.e. you're hitting the 'start' button. Nothing happens the trial number display is updated
            
            finishedForeperiod = false;
            trialIsCancelled = false;
            
            [self displayTrialNumber];
            [self.trialView clearAllResponses];
            [self.trialView changeStartButtonLabelTo:@"WAIT"];
            self.lastTrialStatus.text = @"WAIT";
  //          self.lastTrialStatus.backgroundColor = [UIColor redColor];
            
            [self.trialView presentForeperiod];
            
            
            // don't bother incrementing the trial number just yet -- that can wait till you hit a response button
            // Don't do anything else.  The next action will happen when the Stimulus/Start button is released
            
            // Note: adding an animation here to get a delay before showing the next stimulus won't work.
     
            
        } else {  // a Response key has been pressed...
            
            if (finishedForeperiod){
                
                response.responseTime = time-prevTime; // subtract for the animation time.
                
                // get the all-time percentile for this response and cummulatively add it.
                [self.results saveResult:response];  // save the result first, or you risk crashing when you calculate percentileOfResponse
                
                double responsePercentile = [self.results percentileOfResponse:response];
                rollingResponsePercentile = rollingResponsePercentile + responsePercentile/[MaxTrialsPerSession doubleValue];
                NSLog(@" percentile = %0.3f RP=%0.3f",responsePercentile, rollingResponsePercentile);
                self.sessionResults = rollingResponsePercentile ;
                
                // add it from a rolling mean
                [self displayTrialNumber];
                self.lastTrialStatus.backgroundColor = nil;
                self.lastTrialStatus.text = [[NSString alloc] initWithFormat:@"%0.0fmSec (%0.0f%%)",(time-prevTime)*1000,responsePercentile*100];
                
                [self.trialView clearAllResponses]; // wipe the response key so you can't press it again
                
                if ([self incrementTrialNumber]) { // true if you're over the MaxTrials, so post notification and exit
                    [self.results saveSession:self.sessionResults];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayResponsePercentile" object:self];
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {  // you're not over the Max trials, so no need to do anything special, but note that the currentTrialNumber is now incremented
                    [self displayTrialNumber];
                    [self.trialView changeStartButtonLabelTo:@"Press and Hold"];
                    
                }
                
            } else {
                // foreperiod is not over!
                self.BTSessionScoreLabel.text = @"Press Start to redo cancelled trial";
                finishedForeperiod = true;
                
            }
        } // end: a response key was pressed
    } // end: response was a stimulus
}


// an NSNotification will call this method when the animation for a foreperiod is complete.
// When you're here, it means the user better be trying to hit the response target.
- (void) didFinishForeperiod {
    
    if (trialIsCancelled) { // forePeriod ends prematurely when user lets up on start button
      //  finishedForePeriod = true;
      //  trialIsCancelled = false;
        [self.trialView clearAllResponses];
        
    } else {
    
    self.lastTrialStatus.text = @"GO";
    finishedForeperiod = true;
        trialIsCancelled = false;
        [self.trialView presentNewStimulusResponse];

    }
    
  //  self.lastTrialStatus.backgroundColor = [UIColor greenColor];
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
        
        if (finishedForeperiod) {
        prevTime = time;  // begin the clock that measures how long it takes to press the Response button
           //[self.trialView presentNewStimulusResponse];
            trialIsCancelled = false;
        // load up a randomly-selected mole
        } else {
            self.lastTrialStatus.text = @"Cancelled trial";
            [self.trialView clearAllResponses];
            trialIsCancelled = true;
            [self.trialView changeStartButtonLabelTo:@"Start Again"];

        }

        
    
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
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) viewWillAppear:(BOOL)animated {
    
    [self.trialView clearAllResponses];
    
    
    finishedForeperiod = false;
    trialIsCancelled = false;
    
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
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishForeperiod) name:@"finishedAnimationForMoleDisappearance" object:nil];
}



@end
