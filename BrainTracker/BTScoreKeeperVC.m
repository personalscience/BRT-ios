//
//  BTScoreKeeperVC.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTScoreKeeperVC.h"

// import all classes for the BrainTracker model
#import "BTStimulus.h"
#import "BTResponse.h"
#import "BTTimer.h"
#import "BTResultsTracker.h"

@interface BTScoreKeeperVC ()

@property (strong,nonatomic) BTStimulus *randomNumberStimulus;
@property  uint stimulus;
@property (strong,nonatomic) BTResponse *responseFromUser;
@property (strong, nonatomic) BTResultsTracker *results;

@property (strong, nonatomic) NSDate *lastTime;

@property BOOL alreadyResponded; // makes sure you don't respond to the same stimulus more than once.

@property (strong, nonatomic) BTTimer *roundTimer;  // a timer for this particular round of the test.
@property (weak, nonatomic) IBOutlet UILabel *stimulusNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;




@property (weak, nonatomic) IBOutlet UIView *stimulusPresenter; // view where we show the stimulus.


@end

@implementation BTScoreKeeperVC
@synthesize randomNumberStimulus;


-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"BrainTrackerResultsFile.csv"];
}

- (void) saveToDisk: (NSString *) inputString  duration: (NSTimeInterval) duration comment: (NSString *) comment{
    
    NSString *textToWrite = [[NSString alloc] initWithFormat:@"%@,%@,%f,%@\n",[NSDate date], inputString,duration,comment];
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
    //say to handle where's the file fo write
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    //position handle cursor to the end of file
    [handle writeData:[textToWrite dataUsingEncoding:NSUTF8StringEncoding]];
    
}

- (BTResultsTracker *) results {
    
    if(!_results) {
        _results = [[BTResultsTracker alloc] init];
        self.results = _results;
    }
    return _results;
    
}

- (BTTimer *) roundTimer {
    
    if (!_roundTimer) {_roundTimer = [[BTTimer alloc] init];}
    return _roundTimer;
    
}

- (void) setRandomNumberStimulus {
    if (!self.randomNumberStimulus) self.randomNumberStimulus = [[BTStimulus alloc] init ];
    
    
}

- (BTStimulus *) getRandomNumberStimulus {
    if (!self.randomNumberStimulus) {self.randomNumberStimulus = [[BTStimulus alloc] init];}
    return self.randomNumberStimulus;
}

- (IBAction)responseButtonPressed:(UIButton*)sender {
    // check if the response matches the stimulus, and if so, save to ResultsTracker
    
    if ([sender isKindOfClass:[ UIButton class]]){
        
        
        NSTimeInterval duration = [self.roundTimer elapsedTime];
        
        BTResponse *thisResponse = [[BTResponse alloc] initWithString:sender.titleLabel.text];
        
        if ([self.randomNumberStimulus matchesStimulus:thisResponse] & !self.alreadyResponded) {
            NSLog(@"success: response matches stimulus");
          //  [thisResponse setResponseTime:duration];  // means the same thing as below:
            thisResponse.responseTime = duration;

   
            [self.results saveResult:thisResponse];
            
            double g=[self.results percentileOfResponse:thisResponse];
        
            self.timeLabel.text = [[NSString alloc] initWithFormat:@"%3.2f mSec\nPress to try again\nPercentile=%2.3f",duration * 1000,g];
            self.stimulusPresenter.backgroundColor = [UIColor blackColor];
            
            [self saveToDisk:sender.titleLabel.text duration:duration comment:@"empty comment here"];
            self.alreadyResponded = YES;
        }
        
            else NSLog(@"failure: response doesn't match stimulus");
    }
    
}

- (IBAction)startButtonPressed:(id)sender {


    self.timeLabel.text=@"";
    self.stimulusPresenter.alpha = 0.0;  // view is invisible
    self.stimulusPresenter.backgroundColor = [UIColor redColor];
    self.waitLabel.alpha = 1.0;
   
    self.alreadyResponded=NO;
    
 //   [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(occludeStimulusView) userInfo:nil repeats:NO];
    
    
    [UIView animateWithDuration:2.0 // + arc4random() // wait up to 3 sec
                          delay:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.stimulusPresenter.alpha = 1.0;}
                     completion:^(BOOL success){
                         uint stim = [self.randomNumberStimulus newStimulus];
                         
                         self.stimulusPresenter.backgroundColor = [UIColor greenColor];
                         self.waitLabel.alpha = 0.0;
                         self.stimulusNumberLabel.text = [[NSString alloc] initWithFormat:@"%d",stim];
                         
                         [self.roundTimer startTimer];}
     ];
    
    // self.stimulusPresenter.alpha = 1.0;
    NSLog(@"finished animation")    ;
    
    
/// test code below
    
/*
    
    [NSThread sleepForTimeInterval:2.0];
    
 
 uint stim = [self.randomNumberStimulus newStimulus];
 
 self.stimulusNumberLabel.text = [[NSString alloc] initWithFormat:@"%d",stim];
 
 [self.roundTimer startTimer];
 
 self.stimulusPresenter.alpha = 1.0;
 
*/ //^^^^^^
    
    self.stimulusNumberLabel.text = @"";

}


- (void) prepareUserResponse {
    
    
}


- (void) occludeStimulusView { // puts something on top of the StimulusView so you can't see the numberst
    

//    [UIView animateWithDuration:0.5
//                          delay:0.0
//                        options:UIViewAnimationOptionBeginFromCurrentState
//                     animations:^{self.stimulusPresenter.alpha = 1.0;}
//                     completion:^(BOOL success){
//                         uint stim = [self.randomNumberStimulus newStimulus];
//                         
//                         self.stimulusNumberLabel.text = [[NSString alloc] initWithFormat:@"%d",stim];
//                         
//                         [self.roundTimer startTimer];}
//     ];
//  
//   // self.stimulusPresenter.alpha = 1.0;
//    NSLog(@"finished animation")    ;
//    
    
    
}
- (IBAction)timerButtonPressed:(id)sender {
    
    self.timeLabel.text = [[NSString alloc] initWithFormat:@"%3.0f mSec",1000 *[[NSDate date] timeIntervalSinceDate:self.lastTime]];
    self.lastTime=[NSDate date];
    
}

- (void) doInitializationsIfNecessary {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
        NSLog(@"new results file created");
        NSString *textToWrite = [[NSString alloc] initWithFormat:@"date,string,time,comment\n"];
        NSFileHandle *handle;
        handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
        //say to handle where's the file fo write
        //       [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        //position handle cursor to the end of file
        [handle writeData:[textToWrite dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
  [self occludeStimulusView];  // hide the stimulus in a fancy way
    
    [self doInitializationsIfNecessary];
    
    self.stimulusPresenter.backgroundColor = [UIColor blackColor];
    self.waitLabel.alpha = 0.0;
    
    self.stimulusPresenter.alpha = 1.0;
    self.stimulusNumberLabel.text = @"";
    self.randomNumberStimulus = [[BTStimulus alloc] init];
    self.alreadyResponded = NO;
    self.timeLabel.text = @"Press to Start";
    
    self.lastTime = [NSDate date];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
