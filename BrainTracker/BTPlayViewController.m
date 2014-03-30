//
//  BTPlayViewController.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/24/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTPlayViewController.h"
#import "BTStimulusResponseView.h"

@interface BTPlayViewController ()<TouchReturned>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *difLabel;
@property NSTimeInterval prevTime;
@property (strong, nonatomic)  BTStimulusResponseView *StartButtonView;
@property (weak, nonatomic) IBOutlet BTStimulusResponseView *tempFrame;

@end

@implementation BTPlayViewController


- (void) didReceiveTouchAtTime: (NSTimeInterval) time from:(uint)idNum {
    
    self.timeLabel.text = [[NSString alloc] initWithFormat:@"Touch Time:%f",time];
    

    
    self.difLabel.text = [[NSString alloc] initWithFormat:@"msec since last touch: %f",(time-self.prevTime)*1000];
    
    self.prevTime = time;
    [self.StartButtonView drawRed];
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    
 //   NSTimeInterval time = [[touches anyObject] timestamp];
    

    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSTimeInterval time = [[touches anyObject] timestamp];
    
    self.timeLabel.text =[[NSString alloc] initWithFormat:@"Touch ended:%f",time];
    [self.StartButtonView drawGreen];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    self.StartButtonView = [[BTStimulusResponseView alloc] initWithFrame:self.tempFrame.frame id:4];
    self.StartButtonView.delegate = self;
    [self.tempFrame removeFromSuperview];
    [self.view addSubview:self.StartButtonView];
   // self.tempFrame = self.StartButtonView;
    self.prevTime = 0.0;
    
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
