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
//#import "BTSession.h"

@interface BTSessionVC ()<BTTouchReturned, UIActionSheetDelegate>

// Whatever view you create in Storyboard gets instantiated into trialViewPlaceHolder
// That placeholder is replaced with, in this case, BTMoleWhackViewer.

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

 bool kBTPrecisionControl;



@implementation BTSessionVC
{
    NSNumber *MaxTrialsPerSession;
    NSNumber *currentTrialNumber;
    NSNumber *latencyCutOffValue;
    double rollingResponsePercentile; // add all the percentiles until
    NSTimeInterval prevTime;
    
    bool finishedForeperiod;
    bool trialIsCancelled;
    bool pressedStartButtonOnce;
    
    bool runTheTrial;
    uint foreperiodCount;
    
    bool precisionControl;
    
    NSNotification *didFinishForeperiod;

}

- (BTResultsTracker *) results {
    
    if(!_results) {
        _results = [[BTResultsTracker alloc] init];
        self.results = _results;
    }
    return _results;
    
}


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
    
    if([currentTrialNumber compare:MaxTrialsPerSession]==NSOrderedDescending){
        overMax = YES;
    }
    
    return overMax;
    
}


- (void) processResponse: (BTResponse *) response {
    // get the all-time percentile for this response and cummulatively add it.
    [self.results saveResult:response];  // save the result first, or you risk crashing when you calculate percentileOfResponse
    
    double responsePercentile = [self.results percentileOfResponse:response];
    rollingResponsePercentile = rollingResponsePercentile + responsePercentile/[MaxTrialsPerSession doubleValue];
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
        BTSession *newSession = [[BTSession alloc] init];
        newSession.sessionComment = self.sessionComments;
    
        newSession.sessionScore = [NSNumber numberWithDouble:self.sessionResults];
        
        [self.results saveSession:newSession];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"displayResponsePercentile" object:self];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {  // you're not over the Max trials, so no need to do anything special, but note that the currentTrialNumber is now incremented
        [self displayTrialNumber];
        [self.trialView changeStartButtonLabelTo:@"Press and Hold"];
        
    }
    
}

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
        NSLog(@"Start Button: runThetrial is true");
     
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
            
          //  [self.trialView presentNewStimulusResponse];
           // prevTime = [[NSProcessInfo processInfo] systemUptime];
        }
        
    } else { //NSLog(@"finishedForeperiod = true, TrialisCancelled=false, foreperiodCount=%d",foreperiodCount);
        if ([self isFinalForeperiod]) {
            NSLog(@"final");
            finishedForeperiod = true;
            runTheTrial = true;
            foreperiodCount= 0;
        
        self.lastTrialStatus.text = @"GO";

        [self.trialView presentNewStimulusResponse];
        prevTime = [[NSProcessInfo processInfo] systemUptime];
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
           // foreperiodCount = 0;
          //  if (trialIsCancelled) NSLog(@"trialIsCancelled=true"); else NSLog(@"trialIsCancelled=false");
     
      //  trialIsCancelled = true;
      /*      self.lastTrialStatus.text = @"GO";
            if (!trialIsCancelled) {
            [self.trialView presentNewStimulusResponse];
                prevTime = [[NSProcessInfo processInfo] systemUptime];}
            trialIsCancelled = false;
       */
            
        }
        
        
        
    }
    
}

#pragma mark Touch Handling

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
        
                response.responseLatency = time-prevTime; // subtract for the animation time.
                
                if ([self.results isUnderCutOff:time-prevTime]) {
                    
                    [self processResponse:response];
                    


                } else {
                    NSLog(@"%0.2f is over cutoff",time-prevTime);
                    self.lastTrialStatus.text=@"Too Long";
                }
                
                
                

                
                [self.trialView clearAllResponses]; // wipe the response key so you can't press it again
                

                
        
    }
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
    
    if (!latencyCutOffValue) {NSLog(@"no latency cuttoff value");}
    
    
    finishedForeperiod = false;
    trialIsCancelled = false;
    runTheTrial = true;
    if( kBTPrecisionControl) { precisionControl =  YES;} else precisionControl = NO;
    
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
