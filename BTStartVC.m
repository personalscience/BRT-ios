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
#import "BTResponse.h"
//#import "BTTimer.h"
#import "BTResultsTracker.h"

#define TOTAL_STIMULI 7

@interface BTStartVC ()


@property (strong, nonatomic) IBOutlet BTWedgeView *view;  // created as an outlet in Storyboard,
//it's actually the view for this VC.



@property  NSTimeInterval startPressTime;
@property uint numWedges;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stimulusNumberLabel;


// used by Model

@property  uint stimulus;
@property (strong,nonatomic) BTResponse *responseFromUser;
@property (strong, nonatomic) BTResultsTracker *results;

@property (strong, nonatomic) NSDate *lastTime;

@property BOOL alreadyResponded; // makes sure you don't respond to the same stimulus more than once.

//@property (strong, nonatomic) BTTimer *roundTimer;  // a timer for this particular round of the test.
@end

@implementation BTStartVC
{
    int randomNumberStimulus;
}


# pragma mark - Setters/Getters

- (BTResultsTracker *) results {
    
    if(!_results) {
        _results = [[BTResultsTracker alloc] init];
        self.results = _results;
    }
    return _results;
    
}

//- (BTTimer *) roundTimer {
//    
//    if (!_roundTimer) {_roundTimer = [[BTTimer alloc] init];}
//    return _roundTimer;
//    
//}



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
                         randomNumberStimulus = arc4random() % TOTAL_STIMULI;
                         self.stimulusNumberLabel.textColor = [UIColor blackColor];
                         self.stimulusNumberLabel.text = [[NSString alloc] initWithFormat:@"%d",randomNumberStimulus];
                         self.startPressTime = time + animateDelay;
                //         [self.roundTimer startTimer];
                     }
     ];
    
    
}

- (void)  responsePressed: (NSString *) responseString atTime: (NSTimeInterval) time {
    NSTimeInterval duration = time - self.startPressTime; 
    
    BTResponse *thisResponse = [[BTResponse alloc] initWithString:responseString];
    BTResponse *thisStimulus = [[BTResponse alloc] initWithString:[[NSString alloc] initWithFormat:@"%d",randomNumberStimulus]];
    
    if ([thisStimulus matchesResponse:thisResponse]& !self.alreadyResponded) {
        NSLog(@"success: response matches stimulus");
        //  [thisResponse setResponseTime:duration];  // means the same thing as below:
        thisResponse.responseTime = duration;
        
        
        
        [self.results saveResult:thisResponse];
        
        double g=[self.results percentileOfResponse:thisResponse];
        
        self.timeLabel.text = [[NSString alloc] initWithFormat:@"%3.0f mSec (%2.3f)%%",duration * 1000,g*100];
 
        self.alreadyResponded = YES;
        self.stimulusNumberLabel.textColor = [UIColor blackColor];
        self.stimulusNumberLabel.text = @"Start";

    }
    
    else NSLog(@"failure: response doesn't match stimulus");
}


- (void) viewWillAppear:(BOOL)animated {
    [self.view setNeedsDisplay];
        self.timeLabel.text = @"Score";
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  //  [self setupWedges];
    
    randomNumberStimulus = arc4random() % TOTAL_STIMULI;
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
