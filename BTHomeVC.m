//
//  BTHomeVC.m
//  BrainTracker
//
//  Created by Richard Sprague on 4/2/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTHomeVC.h"
#import "BTSessionVC.h"

@interface BTHomeVC ()
@property (weak, nonatomic) IBOutlet UILabel *latestSessionResultLabel;
@property (strong, nonatomic) BTSessionVC *nextView;

@end

@implementation BTHomeVC

- (IBAction) unwindToMainMenu: (UIStoryboardSegue*)sender {
    
    self.latestSessionResultLabel.text = [[NSString alloc] initWithFormat:@"Last Session Mean: %0.2f",self.nextView.sessionResults];
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToMoleSession"]){
        
        self.latestSessionResultLabel.text =@"switching to Mole Session";
        
        self.nextView = [segue destinationViewController];
        
        BTSessionVC *session = [[BTSessionVC alloc] init];
        
        session.lastVC = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unwindToMainMenu:) name:@"displayResponsePercentile" object:nil];
    
        

    }
    else
        NSLog(@"segue=%@",segue.identifier);
    
}

    



@end
