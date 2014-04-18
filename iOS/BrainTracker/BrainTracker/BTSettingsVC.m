//
//  BTSettingsVC.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTSettingsVC.h"
#import "BTData.h"
#import "BTResponse.h"

@interface BTSettingsVC ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UIStepper *trialsPerSessionStepper;
@property (weak, nonatomic) IBOutlet UILabel *trialsPerSessionLabel;
@end

NSString * const kBTMaxTrialsPerSessionKey = @"trialsPerSession";

@implementation BTSettingsVC
{
    NSNumber *trialsPerSession;
}

- (IBAction)pressedTrialsPerSessionStepper:(id)sender {
    
    if ([sender isKindOfClass:[UIStepper class]]){
        if (trialsPerSession){
            
            trialsPerSession = [NSNumber numberWithInt:(int)self.trialsPerSessionStepper.value];
            [[NSUserDefaults standardUserDefaults] setObject:trialsPerSession forKey:kBTMaxTrialsPerSessionKey];
            self.trialsPerSessionLabel.text = [[NSString alloc] initWithFormat:@"%d",[trialsPerSession intValue] ];
            
        } else NSLog(@"error: unknown settings for trials per session");
        
    }
    
   
}

#pragma mark Test Methods for Filling the Database

- (NSDate *) startDate {
    
    NSString *Jan1ThisYear = @"01-Jan-2014";
    NSDateFormatter *Jan1Formatted = [[NSDateFormatter alloc] init];
    Jan1Formatted.dateFormat = @"dd-MMM-yyyy";
    NSDate *Jan1date = [Jan1Formatted dateFromString:Jan1ThisYear];
    
    
    return Jan1date;
}

- (NSString *) randomString {
    
    
    NSArray *rs = @[@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    uint num = arc4random() % [rs count];
    return rs[num];
    
}

- (NSTimeInterval) randomDays {  // a random number of days between 0 and 65 (expressed as timeInterval)
    
    int oneDay = 24*60*60;
 //   int oneWeek = oneDay*7;
    
    NSTimeInterval days = ((double) (arc4random() % oneDay)) * 65;
    
    return days;
    
}

- (void) fillOneItemInDatabase {
    BTResponse *response = [[BTResponse alloc] initWithString:[self randomString]];
    
  //  double val = ((double)arc4random() / 0x100000000);
    
    double margin = (500.0 + ((double) (arc4random() % 100)))/1000.0; // between 500 and 600 ms

    
    response.responseTime = margin;
    
    
    NSDate *randomDateSinceJan1 = [NSDate dateWithTimeInterval:[self randomDays] sinceDate:[self startDate]]; //
    
    BTData *BTDataResponse = [NSEntityDescription insertNewObjectForEntityForName:@"BTData" inManagedObjectContext:self.context];
    
    BTDataResponse.responseTime = response.response[kBTResponseTimeKey];
    BTDataResponse.responseString = response.response[kBTResponseStringKey];
    BTDataResponse.responseDate = randomDateSinceJan1;
    
    
}

- (IBAction)pressFillDatabase:(id)sender {
    for (uint i = 0;i<10;i++) {
        [self fillOneItemInDatabase];
    }
}


- (NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (void) doInitializationsIfNecessary {
    
    trialsPerSession = [[NSUserDefaults standardUserDefaults] objectForKey:kBTMaxTrialsPerSessionKey];
    
    if (!trialsPerSession){ // first time user
        [[NSUserDefaults standardUserDefaults] setObject:@32 forKey:kBTMaxTrialsPerSessionKey];
    }
    trialsPerSession = [[NSUserDefaults standardUserDefaults] objectForKey:kBTMaxTrialsPerSessionKey];

    self.trialsPerSessionLabel.text=[[NSString alloc] initWithFormat:@"%d",[trialsPerSession intValue]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.context = [self managedObjectContext];
    [self doInitializationsIfNecessary];
    
    trialsPerSession = [[NSUserDefaults standardUserDefaults] objectForKey:kBTMaxTrialsPerSessionKey];
    self.trialsPerSessionLabel.text = [trialsPerSession description];
   
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
