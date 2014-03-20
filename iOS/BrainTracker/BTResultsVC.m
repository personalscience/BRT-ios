//
//  BTResultsVC.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/7/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
#import "BTData.h"
#import "BTResultsVC.h"
#import "BTResultsTracker.h"

@interface BTResultsVC ()<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) BTData *BTResponse;
@property (weak, nonatomic) IBOutlet UILabel *countLable;

//@property (strong, nonatomic) NSArray *results;

@end

@implementation BTResultsVC


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];  //1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];  //[self.results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BTResultsTrackerTableViewRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    BTData *item  = [self.fetchedResultsController objectAtIndexPath:indexPath]; //[self.results objectAtIndex:indexPath.row];
    
    
    NSTimeInterval responseTime = [item.responseTime doubleValue]; //[[item valueForKey:KEY_RESPONSE_TIME] doubleValue]; //[self.BTResponse.responseTime doubleValue]; //
    NSString *responseDate = [NSDateFormatter localizedStringFromDate:item.responseDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterLongStyle]; //[NSDateFormatter localizedStringFromDate:self.BTResponse.responseDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterLongStyle]; 
    
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%3.2f",responseTime];
    cell.detailTextLabel.text = responseDate;//
    
    return cell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (void) viewWillAppear:(BOOL)animated {
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
   // self.BTResponse = [NSEntityDescription insertNewObjectForEntityForName:@"BTData" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"BTData"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"responseDate" ascending:NO],
                                     [NSSortDescriptor sortDescriptorWithKey: @"responseTime" ascending:YES]];
                                      
                                
 //   self.results = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self; 
    
    NSError *error;
    bool success = [self.fetchedResultsController performFetch:&error];
    
    if (!success) {NSLog(@"no results from Fetch: %@",error.description);}
    
    self.countLable.text = [[NSString alloc] initWithFormat:@"count=%lu",(unsigned long)[[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects]];
    
    
    [self.resultsTableView reloadData];
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

@end
