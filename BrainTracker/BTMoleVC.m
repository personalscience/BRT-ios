//
//  BTMoleVC.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/28/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTMoleVC.h"
#import "BTResultsTracker.h"
#import "BTResponse.h"
//#import "BTStimulusResponseView.h"
#import "BTResponseView.h"
#import "BTStartView.h"

const CGFloat kMoleHeight = 50;
const uint kMoleNumCols = 2;
const uint kMOleNumRows = 3;
const uint kMoleCount = kMOleNumRows * kMoleNumCols;


@interface BTMoleVC ()<BTTouchReturned>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong,nonatomic) BTStartView *startButton;
@property (strong, nonatomic) NSArray *moles;  // an array of BTResponseview

@property (strong, nonatomic) BTResultsTracker *results;

@end

@implementation BTMoleVC
{
    NSTimeInterval prevTime;
    CGRect myFrame;
    CGFloat height;
    CGFloat width;
    
}



# pragma mark - Setters/Getters

- (BTResultsTracker *) results {
    
    if(!_results) {
        _results = [[BTResultsTracker alloc] init];
        self.results = _results;
    }
    return _results;
    
}



# pragma mark not needed

- (UIImage *)createImage
{
	UIColor *color = [UIColor redColor];
    
    CGSize size = CGSizeMake(kMoleHeight, kMoleHeight);
	CGRect rect = (CGRect){.size = size};
    
	UIGraphicsBeginImageContext(size);
    
	// Create a filled ellipse
	[color setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path fill];
	
	
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}

    
#pragma mark handle touches

- (void)didFinishForeperiod {
    
    NSLog(@"finished foreperiod in BTMoleVC");
}


- (BTStartView *) makeStartButton: (CGRect) frame {
    
    
    BTResponse *response = [[BTResponse alloc] initWithString:[[[NSNumberFormatter alloc] init] stringFromNumber:@0]]; // by convention, start button is always id=0
    BTStartView *button = self.startButton = [[BTStartView alloc] initWithFrame:frame forResponse:response ];
    self.startButton.delegate = self;
    [self.view addSubview:self.startButton];
    
    return button;
    
}

- (void)didPressStartButtonAtTime:(NSTimeInterval)time {
    
    
    
}

/*
- (void)didReceiveResponse:(BTResponse *)response atTime:(NSTimeInterval)time {
    if ([response isStimulus]){
        for (int i=1;i<=kMoleCount ;i++){
            [[self.moles objectAtIndex:i] setAlpha:0.0];
            
        }
    } else {
        NSTimeInterval duration = time - prevTime;
        
        response.responseLatency = duration;
        
        
        
        [self.results saveResult:response];
        
        double g=[self.results percentileOfResponse:response];
        
        self.timeLabel.text = [[NSString alloc] initWithFormat:@"%3.0f mSec (%2.3f)%%",duration * 1000,g*100];
        
        [self.startButton drawGreen];
  /// deprecated       [[self.moles objectAtIndex:[[response idNum] intValue]] setAlpha:0.0];
        
        // self.timeLabel.text = [[NSString alloc] initWithFormat:@"Time:%3.1f mSec item:%d",1000*(time - prevTime) ,idNum];
    }
    prevTime = time;
    
    
}

- (void) didReceiveTouchAtTime:(NSTimeInterval)time from:(uint)idNum{
    
    if (idNum == 0){
        for (int i=1;i<=kMoleCount ;i++){
            [[self.moles objectAtIndex:i] setAlpha:0.0];
            
        }
    } else {
        NSTimeInterval duration = time - prevTime;
        
        BTResponse *thisResponse = [[BTResponse alloc] initWithString:[[NSString alloc] initWithFormat:@"%d",idNum]];
        thisResponse.responseLatency = duration;
        
        
        
        [self.results saveResult:thisResponse];
        
        double g=[self.results percentileOfResponse:thisResponse];
        
        self.timeLabel.text = [[NSString alloc] initWithFormat:@"%3.0f mSec (%2.3f)%%",duration * 1000,g*100];
        
        [self.startButton drawGreen];
        [[self.moles objectAtIndex:idNum] setAlpha:0.0];
        
       // self.timeLabel.text = [[NSString alloc] initWithFormat:@"Time:%3.1f mSec item:%d",1000*(time - prevTime) ,idNum];
    }
    prevTime = time;
}

- (void) didStopTouchAtTime:(NSTimeInterval)time {
    
    int randomMole = arc4random() % kMoleCount + 1; // ignore the first mole
    
    BTResponseView *response = [self.moles objectAtIndex:randomMole];
    response.alpha = 1.0;
    
        prevTime = time;
   
}

 */
#pragma mark lay out 

- (void) layOutViewsInRows {
    
    NSMutableArray *Moles = [[NSMutableArray alloc] init];
    
//    CGRect myFrame = self.view.frame; // now I can calculate the size of the current view.
//    CGFloat height = myFrame.size.height;
//    CGFloat width = myFrame.size.width;
    
    BTStartView *button = [self makeStartButton:CGRectMake(width/(2)-kMoleHeight*3/2, height - kMoleHeight*2, kMoleHeight*3, kMoleHeight)];
    [button drawColor:[UIColor orangeColor]];
    
    [Moles addObject:button];
    
    CGFloat leftMargin = width/(kMoleNumCols *2) - kMoleHeight/2;
    
    CGFloat verticalSpacing = height/(kMOleNumRows+1);
    uint index = 1;
    
    for (int row=0;row<3;row++){
        for (int col =0;col<kMoleNumCols;col++){
            
            BTResponse *response = [[BTResponse alloc] initWithString:[[[NSNumberFormatter alloc] init] stringFromNumber:[NSNumber numberWithInt:index++]]]; // by convention, start button is always id=0
            
            BTResponseView *newMole = [[BTResponseView alloc]
                                               initWithFrame:CGRectMake(
                                                                        (leftMargin)+col*(width/kMoleNumCols),
                                                                        verticalSpacing+ row*(height/(kMOleNumRows*2)),
                                                                        kMoleHeight,
                                                                        kMoleHeight)
                                               forResponse:response];
            newMole.delegate = self;
            [self.view addSubview:newMole];
            
            
            [Moles addObject:newMole];
        }
    }
    
    self.moles = [[NSArray alloc] initWithArray:Moles ];
    
    
    
}

- (void) layOutViewsInArc {
    
    NSMutableArray *Moles = [[NSMutableArray alloc] init];
    
    CGFloat verticalCenter =width/2;
    
    BTStartView *button = [self makeStartButton:CGRectMake(kMoleHeight/2 + verticalCenter-kMoleHeight*3/2, height - kMoleHeight*2, kMoleHeight*3, kMoleHeight)];
    [button drawColor:[UIColor orangeColor]];
    
    [Moles addObject:button];
    
    CGFloat kRuleHeight = height - height/2;
    CGFloat kLineLen = sqrtf(powf(verticalCenter,2)+powf(height - kRuleHeight,2));
    
    CGFloat theta = atanf((verticalCenter)/(height - kRuleHeight));
    
    CGFloat thetaPiece = 2*theta/5;
    int i = 0;
    uint index = 1;
    
    while (i<6) {
        CGFloat lenOpp = kLineLen * sinf(theta);  // lenght of the side opposite the theta angle
        CGFloat lenAdj = kLineLen * cosf(theta);
        CGFloat x = verticalCenter - lenOpp + kMoleHeight/2;
        CGFloat y = height - lenAdj;
        theta = theta - thetaPiece;
         BTResponse *response = [[BTResponse alloc] initWithString:[[[NSNumberFormatter alloc] init] stringFromNumber:[NSNumber numberWithInt:index++]]]; // by convention, start button is always id=0
        
        BTResponseView *newMole = [[BTResponseView alloc]
                                           initWithFrame:CGRectMake(
                                                                    x-kMoleHeight/2,
                                                                    y-kMoleHeight/2,
                                                                    kMoleHeight,
                                                                    kMoleHeight)
                                           forResponse:response];
        newMole.delegate = self;
        [self.view addSubview:newMole];
        newMole.alpha = 0.0;
        i=i+1;
        [Moles addObject:newMole];
        
    }
    
    
    
    self.moles = [[NSArray alloc] initWithArray:Moles ];
    
}

#pragma mark general

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
 
    
    for (uint i=1;i<[self.moles count]; i++){
        [self.moles[i] setAlpha:0.0];
        [self.moles[i] animatePresenceWithBlink];
    }
    
}

//- (void) viewWillAppear:(BOOL)animated {
//    
//    [super viewWillAppear:animated];
//    
//    
//    
//    for (uint i=1;i<[self.moles count]; i++){
//        [self.moles[i] setAlpha:0.0];
//        //[self.moles[i] animatePresence];
//    }
//    
//}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    myFrame = self.view.frame; // now I can calculate the size of the current view.
    width = myFrame.size.height- kMoleHeight;
    height = myFrame.size.width ;
    for (BTResponseView *mole in self.moles){
        [mole setAlpha:0.0];
    }
    [self layOutViewsInArc];
}

- (void) didRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    myFrame = self.view.frame; // now I can calculate the size of the current view.
    height = myFrame.size.height;
    width = myFrame.size.width - kMoleHeight;
    for (BTResponseView *mole in self.moles){
        [mole setAlpha:0.0];
    }
    [self layOutViewsInArc];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    myFrame = self.view.frame; // now I can calculate the size of the current view.
    height = myFrame.size.height;
    width = myFrame.size.width - kMoleHeight;
    
    
    self.timeLabel.text = @"Press the orange button to start";
    [self layOutViewsInArc];
    

    
}


@end
