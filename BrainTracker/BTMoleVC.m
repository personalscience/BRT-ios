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
#import "BTStimulusResponseView.h"
#import "BTStartView.h"

const CGFloat kMoleHeight = 65;
const uint kMoleNumCols = 2;
const uint kMOleNumRows = 3;
const uint kMoleCount = kMOleNumRows * kMoleNumCols;


@interface BTMoleVC ()<TouchReturned>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong,nonatomic) BTStartView *startButton;
@property (strong, nonatomic) NSArray *moles;

@property (strong, nonatomic) BTResultsTracker *results;

@end

@implementation BTMoleVC
{
    NSTimeInterval prevTime;
    
}
# pragma mark - Setters/Getters

- (BTResultsTracker *) results {
    
    if(!_results) {
        _results = [[BTResultsTracker alloc] init];
        self.results = _results;
    }
    return _results;
    
}

# pragma mark File Handling
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

- (BTStartView *) makeStartButton: (CGRect) frame {
    
    BTStartView *button = self.startButton = [[BTStartView alloc] initWithFrame:frame id:0];  // by convention, start button is always 0
    [self.startButton drawRed];
    self.startButton.delegate = self;
    [self.view addSubview:self.startButton];
    
    return button;
    
}

- (void) didReceiveTouchAtTime:(NSTimeInterval)time from:(uint)idNum{
    
    if (idNum == 0){
        for (int i=1;i<=kMoleCount ;i++){
            [[self.moles objectAtIndex:i] setAlpha:0.0];
            
        }
    } else {
        NSTimeInterval duration = time - prevTime;
        
        BTResponse *thisResponse = [[BTResponse alloc] initWithString:[[NSString alloc] initWithFormat:@"%d",idNum]];
        thisResponse.responseTime = duration;
        
        
        
        [self.results saveResult:thisResponse];
        
        double g=[self.results percentileOfResponse:thisResponse];
        
        self.timeLabel.text = [[NSString alloc] initWithFormat:@"%3.0f mSec (%2.3f)%%",duration * 1000,g];
        
        [self.startButton drawGreen];
        [[self.moles objectAtIndex:idNum] setAlpha:0.0];
        
       // self.timeLabel.text = [[NSString alloc] initWithFormat:@"Time:%3.1f mSec item:%d",1000*(time - prevTime) ,idNum];
    }
    prevTime = time;
}

- (void) didStopTouchAtTime:(NSTimeInterval)time {
    
    int randomMole = arc4random() % kMoleCount + 1; // ignore the first mole
    
    BTStimulusResponseView *response = [self.moles objectAtIndex:randomMole];
    response.alpha = 1.0;
    
        prevTime = time;
   
}

#pragma mark general

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self doInitializationsIfNecessary];
    
    NSMutableArray *Moles = [[NSMutableArray alloc] init];
    
    CGRect myFrame = self.view.frame; // now I can calculate the size of the current view.
    CGFloat height = myFrame.size.height;
    CGFloat width = myFrame.size.width;
    
    BTStartView *button = [self makeStartButton:CGRectMake(width/(2)-kMoleHeight, height - kMoleHeight*2, kMoleHeight*3, kMoleHeight)];
    
    
    [Moles addObject:button];
    
    CGFloat leftMargin = width/(kMoleNumCols *2) - kMoleHeight/2;
    
    CGFloat verticalSpacing = height/(kMOleNumRows+1);
    uint index = 1;
    
    for (int row=0;row<3;row++){
        for (int col =0;col<kMoleNumCols;col++){
        
            BTStimulusResponseView *newMole = [[BTStimulusResponseView alloc]
                                          initWithFrame:CGRectMake(
                                                                   (leftMargin)+col*(width/kMoleNumCols),
                                                                    verticalSpacing+ row*(height/(kMOleNumRows*2)),
                                                                   kMoleHeight,
                                                                   kMoleHeight)
                                          id:index++];
            newMole.delegate = self;
            [self.view addSubview:newMole];
            [newMole setAlpha:0.0];
        
        
        [Moles addObject:newMole];
        }
    }
    
    self.moles = [[NSArray alloc] initWithArray:Moles ];
    
 //   for (BTStartButtonView *mole in Moles){
 //       [mole drawRed];
 //   }
}


@end
