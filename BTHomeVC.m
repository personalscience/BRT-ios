//
//  BTHomeVC.m
//  BrainTracker
//
//  Created by Richard Sprague on 4/2/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTHomeVC.h"

@interface BTHomeVC ()
@property (weak, nonatomic) IBOutlet UIPickerView *whichUIPicker;

@end

@implementation BTHomeVC

- (IBAction) unwindToMainMenu: (UIStoryboardSegue*)sender {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
