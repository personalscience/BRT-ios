//
//  BTStartVC.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/22/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTStartVC.h"
#import "BTWedgeView.h"

// import all classes for the BrainTracker model
#import "BTStimulus.h"
#import "BTResponse.h"
#import "BTTimer.h"
#import "BTResultsTracker.h"

@interface BTStartVC ()
@property (strong, nonatomic) IBOutlet BTWedgeView *view;

@property  NSTimeInterval startPressTime;
@property uint numWedges;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stimulusNumberLabel;


// used by Model
@property (strong,nonatomic) BTStimulus *randomNumberStimulus;
@property  uint stimulus;
@property (strong,nonatomic) BTResponse *responseFromUser;
@property (strong, nonatomic) BTResultsTracker *results;

@property (strong, nonatomic) NSDate *lastTime;

@property BOOL alreadyResponded; // makes sure you don't respond to the same stimulus more than once.

@property (strong, nonatomic) BTTimer *roundTimer;  // a timer for this particular round of the test.
@end

@implementation BTStartVC

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



# pragma mark - Setters/Getters

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

# pragma mark Touch-related

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSTimeInterval time = [[touches anyObject] timestamp];
    
    for (uint w=0;w<=self.numWedges;w++){
        
        if ([self.view.wedges[w] containsPoint:[[touches anyObject] locationInView:self.view]]){
            NSLog(@"touching wedge %d",w);
            if (w==self.numWedges) { // it's the center circle, so treat it like a start button press
                [self startPressedAtTime:time];
                
            } else {
                [self responsePressed:[[NSString alloc] initWithFormat:@"%d",w] atTime:time];
            }
            
        } //else {NSLog(@"No wedge found at %d",w);}
        
        
    }

}

- (void) startPressedAtTime: (NSTimeInterval) time {
    
    self.stimulusNumberLabel.textColor = [UIColor redColor];
    self.stimulusNumberLabel.alpha = 0.0;

    self.stimulusNumberLabel.text = @"WAIT";
        self.alreadyResponded = NO;
    
    NSTimeInterval animateDelay = 2.0; // + arc4random(); // wait up to 3 s
    
    [UIView animateWithDuration:animateDelay // + arc4random() // wait up to 3 sec
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.stimulusNumberLabel.text = @"WAIT";
                         self.stimulusNumberLabel.alpha = 1.0;}
                     completion:^(BOOL success){
                         uint stim = [self.randomNumberStimulus newStimulus];
                         self.stimulusNumberLabel.textColor = [UIColor blackColor];
                         self.stimulusNumberLabel.text = [[NSString alloc] initWithFormat:@"%d",stim];
                         self.startPressTime = time + animateDelay;
                         [self.roundTimer startTimer];}
     ];
    
    
}

- (void)  responsePressed: (NSString *) responseString atTime: (NSTimeInterval) time {
    NSTimeInterval duration = time - self.startPressTime; 
    
    BTResponse *thisResponse = [[BTResponse alloc] initWithString:responseString];
    
    if ([self.randomNumberStimulus matchesStimulus:thisResponse] & !self.alreadyResponded) {
        NSLog(@"success: response matches stimulus");
        //  [thisResponse setResponseTime:duration];  // means the same thing as below:
        thisResponse.responseTime = duration;
        
        
        
        [self.results saveResult:thisResponse];
        
        double g=[self.results percentileOfResponse:thisResponse];
        
        self.timeLabel.text = [[NSString alloc] initWithFormat:@"%3.0f mSec (%2.3f)%%",duration * 1000,g*100];
 
        self.alreadyResponded = YES;
        self.stimulusNumberLabel.textColor = [UIColor blackColor];
        self.stimulusNumberLabel.text = @"Start";
        [self saveToDisk:responseString duration:duration comment:@"empty comment here"];
    }
    
    else NSLog(@"failure: response doesn't match stimulus");
}

/*
- (void) setupWedges {
    
    NSMutableArray *wedges = [[NSMutableArray alloc] init];
    
    
    
    
    for (uint i=0;i<self.numWedges;i++){
        [wedges addObject:[self.view wedge:i]];
    }
    
    [wedges addObject:[self.view circleAtCenterWithRadius:25.0]];
    
  //  self.wedges = [[NSArray alloc] initWithArray:wedges copyItems:YES];
    
}
 */

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

- (void) viewWillAppear:(BOOL)animated {
    //[self.view setNeedsDisplay];
        self.timeLabel.text = @"Score";
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  //  [self setupWedges];
    
    self.randomNumberStimulus = [[BTStimulus alloc] init];
    self.alreadyResponded = NO;
    self.stimulusNumberLabel.text = @"Start";
    self.numWedges = [BTWedgeView numWedges];
    
    self.lastTime = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
