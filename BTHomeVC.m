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
@property (weak, nonatomic) IBOutlet UITextField *sessionDescriptionTextField;

@end

@implementation BTHomeVC

{
    NSString *sessionDescription;
}

- (IBAction) unwindToMainMenu: (UIStoryboardSegue*)sender {
    
    self.latestSessionResultLabel.text = [[NSString alloc] initWithFormat:@"Last Session Mean: %0.0f%%",self.nextView.sessionResults*100];
    
}
- (IBAction)sessionDescriptionDidExit:(id)sender {
    sessionDescription = self.sessionDescriptionTextField.text;
    
    [sender resignFirstResponder];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //conveniently pre-select the text in the description field, because you'll want to change it immediately.
    
    [self.sessionDescriptionTextField setSelectedTextRange:[self.sessionDescriptionTextField textRangeFromPosition:self.sessionDescriptionTextField.beginningOfDocument toPosition:self.sessionDescriptionTextField.endOfDocument]];
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
        self.nextView.sessionComments = [[NSString alloc] initWithString:self.sessionDescriptionTextField.text];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unwindToMainMenu:) name:@"displayResponsePercentile" object:nil];
    
        

    }
    else
        NSLog(@"segue=%@",segue.identifier);
    
}

    



@end
