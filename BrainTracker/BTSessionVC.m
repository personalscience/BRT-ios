//
//  BTSessionVC.m
//  BrainTracker
//
//  Created by Richard Sprague on 4/4/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
// #import "BTGlobals.h"  // see BrainTracker-Prefix.pch
#import "BTSessionVC.h"
#import "BTSession.h"
#import "BTTrial.h"
#import "BTStimulus.h"
#import "BTResponse.h"
#import "BTMoleWhackViewer.h"
#import "BTResultsTracker.h"
//#import "BTSession.h"

@interface BTSessionVC ()<BTTouchReturned, UIActionSheetDelegate>

// Whatever view you create in Storyboard gets instantiated into trialViewPlaceHolder
// That placeholder is replaced with, in this case, BTMoleWhackViewer.

@property (weak, nonatomic) IBOutlet UIView *trialViewPlaceHolder;
@property (strong, nonatomic) BTMoleWhackViewer *trialView;
@property (weak, nonatomic) IBOutlet UILabel *lastTrialStatus;

@property (strong, nonatomic) BTSession * session;
@property (strong, nonatomic) BTTrial *trial;

@property (weak, nonatomic) IBOutlet UILabel *BTSessionScoreLabel;

@property (strong, nonatomic) BTResultsTracker *results;

@end
/*
const CGFloat kMoleHeight = 50;
const uint kMoleNumCols = 2;
const uint kMOleNumRows = 3;
const uint kMoleCount = kMOleNumRows * kMoleNumCols;
*/

 bool kBTPrecisionControl;



@implementation BTSessionVC
{
    NSNumber *MaxTrialsPerSession;
    NSNumber *currentTrialNumber;
    NSNumber *latencyCutOffValue;
    double rollingResponsePercentile; // add all the percentiles until
    NSTimeInterval timeMarkForStartOfTrial; // number of seconds since system went uptime:used for measuring latency
    
    bool finishedForeperiod;
    bool trialIsCancelled;
    bool pressedStartButtonOnce;
    
    bool runTheTrial;
    uint foreperiodCount;
    
    bool precisionControl;
    
    NSNotification *didFinishForeperiod;

}

# pragma mark Setters/Getters

- (BTResultsTracker *) results {
    
    if(!_results) {
        _results = [[BTResultsTracker alloc] init];
        self.results = _results;
    }
    return _results;
    
}

#pragma mark Protocol handlers for BTTouchReturned Protocol
// When you're here, it means the user better be trying to hit the response target.
- (void) didFinishForeperiod {
    finishedForeperiod = false;
    runTheTrial = false;
    
    
    if (trialIsCancelled) { // forePeriod ends prematurely when user lets up on start button
        
        //  trialIsCancelled = false; // reset trialIsCancelled because foreperiod is over
        // [self.trialView clearAllResponses];
        // foreperiodCount--;
        //      NSLog(@"finishedForeperiod = true, TrialisCancelled=True, foreperiodCount=%d",foreperiodCount );
        
        if ([self isFinalForeperiod]) {
            NSLog(@"final with cancelled");
            finishedForeperiod = true;
            runTheTrial = true;
            foreperiodCount= 0;
            self.lastTrialStatus.text = @"GO";
            

        }
        
    } else { //NSLog(@"finishedForeperiod = true, TrialisCancelled=false, foreperiodCount=%d",foreperiodCount);
        if ([self isFinalForeperiod]) {
            NSLog(@"final");
            finishedForeperiod = true;
            runTheTrial = true;
            foreperiodCount= 0;
            
            self.lastTrialStatus.text = @"GO";
            
            [self.trialView presentNewStimulusResponse];
            timeMarkForStartOfTrial = [[NSProcessInfo processInfo] systemUptime];
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
        NSLog(@"stopTouch: foreperiodCount=%d",foreperiodCount);
        
        if (!finishedForeperiod ) {  // foreperiod is not over, so cancel the current trial
            runTheTrial = false;
            self.lastTrialStatus.text = @"Cancelled trial";
            [self.trialView clearAllResponses];
            NSLog(@"finishedForeperiod=False");
            if (trialIsCancelled) {
                
                NSLog(@"...trialIsCancelled=true");
            }
            else {
                NSLog(@"...trialIsCancelled=false");
                
                NSLog(@"...but setting it to true");
                trialIsCancelled = true;
                
            }
            
            [self.trialView changeStartButtonLabelTo:@"Start Again"];
            
        } else { // foreperiod is finished, so you must be releasing this button after having hit start when the trial had already been cancelled
            // NSLog(@"finished foreperiod and released start button");
            runTheTrial = true;
            trialIsCancelled = true;
        }
    }
    
}

- (void) didReceiveResponse:(BTResponse *)response atTime:(NSTimeInterval)time {
    
    
    if([currentTrialNumber compare:MaxTrialsPerSession]==NSOrderedDescending){  // this should never be true, because it should have been caught elsewhere
        NSLog(@"currentTrialNumber=%@ exceeds max allowed=%@",[currentTrialNumber description],[MaxTrialsPerSession description]);
        self.BTSessionScoreLabel.text = [[NSString alloc] initWithFormat:@"Session Score = %0.0f",rollingResponsePercentile];
    } else {  // a Response key has been pressed...
        // the foreperiod is over by the
        //time we get here
        // if (finishedForeperiod){
        
        finishedForeperiod = false;
        trialIsCancelled = false;
        runTheTrial = true;
        
        [self.trial setTrialLatency:[NSNumber numberWithDouble:time-timeMarkForStartOfTrial]];
        
        response.responseLatency = time-timeMarkForStartOfTrial; // subtract for the animation time.
        
        if (
            //[self.results isUnderCutOff:time-timeMarkForStartOfTrial]
            time-timeMarkForStartOfTrial <= kBTLatencyCutOffValue
            
            ) {
            
            [self processResponse:response];
            
            
            
        } else {
            NSLog(@"%0.2f is over cutoff",time-timeMarkForStartOfTrial);
            self.lastTrialStatus.text=@"Too Long";
        }
        
        
        
        
        
        [self.trialView clearAllResponses]; // wipe the response key so you can't press it again
        
        
        
        
    }
}

#pragma mark Trial handling

- (void) displayTrialNumber {
    
    if ([currentTrialNumber intValue]==0){
        self.BTSessionScoreLabel.text = [[NSString alloc] initWithFormat:@"Begin %d Trials",[MaxTrialsPerSession intValue]];
    } else {
        self.BTSessionScoreLabel.text = [[NSString alloc]initWithFormat:@"Press to Start Trial %d of %d",[currentTrialNumber intValue],[MaxTrialsPerSession intValue]];
    }
    
    
}


- (BOOL) incrementTrialNumber {
    bool overMax = NO;
    

     currentTrialNumber = [NSNumber numberWithInt:([currentTrialNumber intValue]+1)];
    self.trial.trialNumber = currentTrialNumber;
    
    if([currentTrialNumber compare:MaxTrialsPerSession]==NSOrderedDescending){
        overMax = YES;
    }
    
    return overMax;
    
}


- (void) processResponse: (BTResponse *) response {

    [self.trial setResponseString:response ];
    self.trial.trialCorrect = @1;
    self.trial.trialInclude = @1;
     
     [self.trial setSession:self.session];
    [self.results saveTrial:self.trial];
    
    // get the all-time percentile for this response and cummulatively add it.
  //  [self.results saveResult:response];  // save the result first, or you risk crashing when you calculate percentileOfResponse
    
    double responsePercentile = [self.results percentileOfResponse:response];
    rollingResponsePercentile = rollingResponsePercentile + responsePercentile/[MaxTrialsPerSession doubleValue];
    // this is intended to be the mean of all the responsePercentiles for this session
 //   NSLog(@" percentile = %0.3f RP=%0.3f",responsePercentile, rollingResponsePercentile);
    self.sessionResults = rollingResponsePercentile ;
   
    // add it from a rolling mean
    [self displayTrialNumber];
    self.lastTrialStatus.backgroundColor = nil;
    
    NSString *latencyText =[[NSString alloc] initWithFormat:@"%0.0fmSec (%0.0f%%)",(response.responseLatency)*1000,responsePercentile*100];
    self.lastTrialStatus.text =latencyText;
    
    
    if (precisionControl){
    
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:[[NSString alloc] initWithFormat:@"KEEP: %@?",latencyText] delegate:self cancelButtonTitle:@"Keep" destructiveButtonTitle:@"Delete" otherButtonTitles:nil] ;
    
    [alert showInView:self.view];
    } else [self makeNextTrial];

    
}

- (void) makeNextTrial {
    if ([self incrementTrialNumber]) { // true if you're over the MaxTrials, so post notification and exit
      
        // self.session.sessionComment = self.sessionComments;
    
        self.session.sessionScore = [NSNumber numberWithDouble:self.sessionResults];
        
        [self.results saveSession:self.session];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"displayResponsePercentile" object:self];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {  // you're not over the Max trials, so no need to do anything special, but note that the currentTrialNumber is now incremented
        [self displayTrialNumber];
    
      //  [self.trialView changeStartButtonLabelTo:@"Press and Hold"];
        [self reloadTrialView];
        
    }
    
}

#pragma mark actionSheet delegate handling
-(void) actionSheet: (UIActionSheet*) actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSLog(@"you pressed %d",(int)buttonIndex);
    
    if (buttonIndex == 1){
        [self makeNextTrial];
    
        
    }
    else { NSLog(@"Nothing happens: we're not keeping this result");
        
    }
}

- (void) actionSheetCancel:(UIActionSheet *)actionSheet
{
    

    
}


#pragma mark Touch Handling



// two possibilities:
// you pressed when Foreperiod is not yet finished
// You pressed when you had already cancelled and you want to restart
// this method handles two circumstances:
// 1. You want to begin a trial
//  a. Foreperiod is over: start a new trial
//  b. Foreperiod is not over: ignore the touch
// 2. You want to cancel a trial that is already in progress

- (void) didPressStartButtonAtTime:(NSTimeInterval)time {
    
    
    if (runTheTrial) {//((!trialIsCancelled & !finishedForeperiod)| (trialIsCancelled & finishedForeperiod)){
            //start from scratch, because you're just beginning this trial
            // trialIsCancelled = false;
            // finishedForeperiod = false;
        NSLog(@"Start Button pressed: runThetrial is true");
        self.trial = [[BTTrial alloc] init];
     
            [self displayTrialNumber];
            [self.trialView clearAllResponses];
            [self.trialView changeStartButtonLabelTo:@"WAIT"];
            self.lastTrialStatus.text = @"WAIT";
            //          self.lastTrialStatus.backgroundColor = [UIColor redColor];
            foreperiodCount = 0;
        trialIsCancelled=false;
            [self.trialView presentForeperiod];
        
    }

}

- (bool) isFinalForeperiod {
    
    foreperiodCount++;
    if (foreperiodCount>5) {
    //    NSLog(@"final foreperiod")  ;
        return true;
    } else return false;
    
}







#pragma mark View Methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

    [self.trialView setNeedsDisplay];
}

- (void) didRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.trialView setNeedsDisplay];
   
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) viewWillAppear:(BOOL)animated {
    
    [self.trialView clearAllResponses];
   latencyCutOffValue =[[NSUserDefaults standardUserDefaults] objectForKey:kBTLatencyCutOffValueKey];
    
    if (!latencyCutOffValue) {
        NSLog(@"no latency cuttoff value");
        latencyCutOffValue = [[NSUserDefaults standardUserDefaults] valueForKey:kBTLatencyCutOffValueKey];
        
       [[NSUserDefaults standardUserDefaults] setObject:@3.0 forKey:kBTLatencyCutOffValueKey];
    }
    
    
    finishedForeperiod = false;
    trialIsCancelled = false;
    runTheTrial = true;
    if( kBTPrecisionControl) { precisionControl =  YES;} else precisionControl = NO;
    
}

- (void) reloadTrialView { // every reload gives you a brand new BTMoleWhackViewer
    
    BTStimulus *stimulus = [[BTStimulus alloc] init]; //[[BTStimulus alloc] initWithString:[[[NSNumberFormatter alloc] init] stringFromNumber:@2] ];
    
    self.trialView = [[BTMoleWhackViewer alloc] initWithFrame:self.trialViewPlaceHolder.frame stimulus:stimulus];
    self.trialView.motherViewer = self;
    self.trialView.backgroundColor= [UIColor whiteColor];
    
    [self.trialViewPlaceHolder removeFromSuperview];
    [self.view addSubview:self.trialView];
    [self.trialView makeStartButton];
    self.trialViewPlaceHolder  = self.trialView;
    [self displayTrialNumber];
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MaxTrialsPerSession = [[NSUserDefaults standardUserDefaults] objectForKey:kBTMaxTrialsPerSessionKey];
    self.session = [[BTSession alloc] initWithComment:self.sessionComments];
    
    currentTrialNumber = @1;
    rollingResponsePercentile= 0.0f;


    
    if(!MaxTrialsPerSession){
        NSLog(@"No MaxTrialsPerSessionKey found");
        MaxTrialsPerSession = @32;
        [[NSUserDefaults standardUserDefaults] setObject:MaxTrialsPerSession forKey:kBTMaxTrialsPerSessionKey];
    }
    
    [self reloadTrialView];
    
}



@end
