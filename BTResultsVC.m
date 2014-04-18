//
//  BTResultsVC.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/7/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
#import "BTData.h"
#import "BTDataSession.h"
#import "BTResultsVC.h"
#import "BTResultsTracker.h"

@interface BTResultsVC ()<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) BTDataSession *session;

@property (weak, nonatomic) IBOutlet UILabel *sessionsOrResponsesLabel;

@property (weak, nonatomic) IBOutlet UISwitch *sessionsOrResponsesSwitch;

//@property (strong, nonatomic) NSArray *results;

@end

@implementation BTResultsVC
{
    bool sessionsNotResponses; // if true, then show sessions, not Responses [and vice versa]
}

- (IBAction)sessionsOrResponsesSwitchDidChange:(id)sender {
    
    sessionsNotResponses = !sessionsNotResponses;
    [self updateSessionsOrResponsesLabel];
    [self updateUI];
    
}

// returns an item from the database and checks that it's valid
- (id) itemAtIndexPath: (NSIndexPath *) indexPath {
     id item = (sessionsNotResponses) ?  (BTDataSession *)[self.fetchedResultsController objectAtIndexPath:indexPath] : [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSAssert(([item isKindOfClass:[BTData class]]|[item isKindOfClass:[BTDataSession class]]),@"Trying to show a tableview of something that isn't an expected class");

    
    if ([item isKindOfClass:[BTData class]]) { return (BTData *) item;
    } else { return (BTDataSession *) item; }
    

    
}


- (NSDate *) dateOfItem: (id) item {
    
    BTData *itemAsResponse;
    BTDataSession *itemAsSession;
    
    NSDate *returnItem;
    
     NSAssert(([item isKindOfClass:[BTData class]]|[item isKindOfClass:[BTDataSession class]]),@"Trying to show a tableview of something that isn't an expected class (dateOfItem)");
    
    
    
    if ([item isKindOfClass:[BTDataSession class]]) {
        itemAsSession=item;
        returnItem= itemAsSession.sessionDate;}
    else if ([item isKindOfClass:[BTData class]]){
        itemAsResponse = item;
        returnItem= itemAsResponse.responseDate;
    }
        
    return returnItem;
}


- (NSTimeInterval) timeOfItem: (id) item {
    BTData *itemAsResponse;
    BTDataSession *itemAsSession;
    
    NSAssert(([item isKindOfClass:[BTData class]]|[item isKindOfClass:[BTDataSession class]]),@"Trying to show a tableview of something that isn't an expected class (timeOfItem)");
    
    NSTimeInterval returnItem = 0.0;
    
    if ([item isKindOfClass:[BTData class]]) {
        itemAsResponse=item;
        returnItem = (NSTimeInterval)[itemAsResponse.responseTime doubleValue];
    }    else if ([item isKindOfClass:[BTDataSession class]]){
        itemAsSession = item;
        returnItem =  (NSTimeInterval)[itemAsSession.sessionScore doubleValue];
    }
    

    return returnItem;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
  

    [self.context deleteObject:[self itemAtIndexPath:indexPath]];
    [self.resultsTableView reloadData];
    
}

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
    
 //   BTData *item  = [self.fetchedResultsController objectAtIndexPath:indexPath]; //[self.results objectAtIndex:indexPath.row];
    
    BTDataSession *item = [self itemAtIndexPath:indexPath];
    
    NSTimeInterval resultTime = [self timeOfItem:item];
    NSDate *resultDate = [self dateOfItem:item] ;
    
    
    
    cell.textLabel.text = [self timeText:(double)resultTime];
    cell.detailTextLabel.text = [self dateText:resultDate];
    
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



- (NSString *) dateText: (NSDate *) dateToShow {
      NSString *dateString = [NSDateFormatter localizedStringFromDate:dateToShow dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterLongStyle];
    return dateString;
    
}

// returns text representing the number timeToShow
- (NSString *) timeText: (double) timeToShow {
    
    NSString *timeString = [[NSString alloc]  initWithFormat:@"%3.2f",timeToShow];
    return timeString;
    
}
- (NSFetchRequest *) fetchResponses {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"BTData"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"responseDate" ascending:NO],
                                     [NSSortDescriptor sortDescriptorWithKey: @"responseTime" ascending:YES]];
    
    return fetchRequest;
    
}

- (NSFetchRequest *) fetchSessions {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"BTDataSession"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sessionDate" ascending:NO],
                                     [NSSortDescriptor sortDescriptorWithKey: @"sessionScore" ascending:YES]];
    
    return fetchRequest;
    
}

- (void) updateSessionsOrResponsesLabel {
    
    self.sessionsOrResponsesLabel.text = (sessionsNotResponses) ? @"Sessions" : @"Responses";
    
}

- (NSFetchRequest *) fetchSessionsOrResponses {
    
    if (sessionsNotResponses) { return [self fetchSessions];
    }
    else return [self fetchResponses];
    
}

- (void) updateUI {
    
    
    NSFetchRequest *fetchRequest = [self fetchSessionsOrResponses];
    
    //   self.results = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    bool success = [self.fetchedResultsController performFetch:&error];
    
    if (!success) {NSLog(@"no results from Fetch: %@",error.description);}
    
    self.countLabel.text = [[NSString alloc] initWithFormat:@"count=%lu",(unsigned long)[[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects]];
    
    
    [self.resultsTableView reloadData];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    //   NSManagedObjectContext *context = [self managedObjectContext];
    self.context = [self managedObjectContext];

    [self updateSessionsOrResponsesLabel];

        [self updateUI];
 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    sessionsNotResponses = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
