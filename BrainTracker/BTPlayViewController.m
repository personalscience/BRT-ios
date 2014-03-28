//
//  BTPlayViewController.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/24/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTPlayViewController.h"
#import "BTStartButtonView.h"

@interface BTPlayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *difLabel;
@property NSTimeInterval prevTime;
@property (weak, nonatomic) IBOutlet BTStartButtonView *StartButtonView;

@end

@implementation BTPlayViewController


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    
    NSTimeInterval time = [[touches anyObject] timestamp];
    
    
    
    self.timeLabel.text = [[NSString alloc] initWithFormat:@"Touch Time:%f",time];
    
    self.difLabel.text = [[NSString alloc] initWithFormat:@"msec since last touch: %f",(time-self.prevTime)*1000];
    
    self.prevTime = time;
    [self.StartButtonView drawRed];
    
    
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
