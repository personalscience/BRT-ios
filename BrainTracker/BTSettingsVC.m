//
//  BTSecondViewController.m
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
@end

@implementation BTSettingsVC



- (NSString *) randomString {
    
    
    NSArray *rs = @[@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    uint num = arc4random() % [rs count];
    return rs[num];
    
}

- (void) fillOneItemInDatabase {
    BTResponse *response = [[BTResponse alloc] initWithString:[self randomString]];
    
    double val = ((double)arc4random() / 0x100000000);
    [response setResponseTime:val];
    
    BTData *BTDataResponse = [NSEntityDescription insertNewObjectForEntityForName:@"BTData" inManagedObjectContext:self.context];
    
    BTDataResponse.responseTime = response.response[KEY_RESPONSE_TIME];
    BTDataResponse.responseString = response.response[KEY_RESPONSE_STRING];
    BTDataResponse.responseDate = response.response[KEY_RESPONSE_DATE];
    
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.context = [self managedObjectContext];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
