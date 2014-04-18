//
//  BTPlayViewController.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/24/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//




#import "BTPlayViewController.h"
#import "BTResponseView.h"

@interface BTPlayViewController ()<BTTouchReturned>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *difLabel;
@property NSTimeInterval prevTime;
@property (strong, nonatomic)  BTResponseView *StartButtonView;
@property (weak, nonatomic) IBOutlet BTResponseView *tempFrame;

@property (weak, nonatomic) IBOutlet UIProgressView *brightnessLevel;
@property (weak, nonatomic) IBOutlet UILabel *brightnessLevelLabel;

@end

@implementation BTPlayViewController

{
    
    CGFloat howBright; // uses the screen brightness to guess at the ambient light 
    
}

// this method comes via the <BTTouchReturned> protocol. It means somebody touched an object created by BT
- (void) didReceiveResponse:(BTResponse *)response atTime:(NSTimeInterval)time {
    
    self.timeLabel.text = [[NSString alloc] initWithFormat:@"Touch Time:%0.2f",time];
    

    
    self.difLabel.text = [[NSString alloc] initWithFormat:@"msec since last touch: %0.2f",(time-self.prevTime)*1000];
    
    self.prevTime = time;
    [self.StartButtonView drawRed];
    
    UILabel *newLabel = [[UILabel alloc] init];
    newLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"Again And Again%d",[@100 intValue]]];
    self.StartButtonView.label = newLabel;
    
//    [self.StartButtonView showLabels ];
    
}


// this method applies to the current view controller

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    
 //   NSTimeInterval time = [[touches anyObject] timestamp];
    self.prevTime = [[touches anyObject] timestamp];
    

    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSTimeInterval time = [[touches anyObject] timestamp];
    
    self.timeLabel.text =[[NSString alloc] initWithFormat:@"Touch ended:%f",time];
    [self.StartButtonView drawGreen];
    [self.StartButtonView setAlpha:1.0];
    [self updateBrightessLabel];
 
    
}

- (void) updateBrightessLabel {
    
    howBright = [[UIScreen mainScreen] brightness];
    self.brightnessLevelLabel.text = [[NSString alloc] initWithFormat:@"%0.2f",howBright];
    [self.brightnessLevel setProgress:howBright];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BTResponse *response = [[BTResponse alloc] initWithString:[[[NSNumberFormatter alloc] init] stringFromNumber:@4]];
    
    self.StartButtonView = [[BTResponseView alloc] initWithFrame:self.tempFrame.frame forResponse:response];
    self.StartButtonView.delegate = self;
    
    UILabel *newLabel = [[UILabel alloc] init];
    newLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"Start Now:%d",[@100 intValue]]];
    
    
    self.StartButtonView.label = newLabel;
    
    
    [self.tempFrame removeFromSuperview];
    [self.view addSubview:self.StartButtonView];
   // self.tempFrame = self.StartButtonView;
    self.prevTime = 0.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBrightessLabel) name:UIScreenBrightnessDidChangeNotification object:nil];
    
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
