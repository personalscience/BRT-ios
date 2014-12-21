//
//  BTResultsVC.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/7/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTGlobals.h"
#import "BTDataTrial.h"
#import "BTDataSession+BTAnalysis.h"
#import "BTResultsVC.h"
//#import "BTResultsTracker.h"

#define TARGETLABELTAG 102
#define TIMELABELTAG 101
#define DATELABELTAG 103

@interface BTResultsVC ()<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UILabel *targetOrRoundsLabel;

@property (weak, nonatomic) IBOutlet UILabel *sessionsOrSecondsLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) NSManagedObjectContext *context;

//@property (strong, nonatomic) BTDataSession *session;

@property (weak, nonatomic) IBOutlet UILabel *sessionsOrResponsesLabel;

@property (weak, nonatomic) IBOutlet UISwitch *sessionsOrResponsesSwitch;

//@property (strong, nonatomic) NSArray *results;

@end

@implementation BTResultsVC
{
    bool sessionsNotResponses; // if true, then show sessions, not Responses [and vice versa]
}

#pragma mark Updated Score Computation

// returns an array of trials whose trialResponseString equals the string in response.
// The array is sorted by date, from highest to lowest.
- (NSArray *) trialsMatchingResponse: (NSString *) responseString {
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BTDataTrial" ];
    
    // filter for everything in the database where attribute ResponseString = responseString
    NSPredicate *matchesString = [NSPredicate predicateWithFormat:@"%K matches %@",kBTtrialResponseStringKey,responseString];
    
    //   request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kBTtrialLatencyKey ascending:NO]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kBTtrialTimestampKey ascending:NO]];
    
    // I can just grab the first n responses with this:
 //   request.fetchLimit = kBTlastNTrialsCutoffValue;
    
    
    
    [request setPredicate:matchesString];
    
    
    NSError *error ;
    NSArray *results = [self.context executeFetchRequest:request error:&error  ];
    
    NSAssert(!error, @"error fetching trials to match response: (%@) : %@",responseString,[error localizedDescription]);
    
    // results is an NSArray of every response that matched this stimulus
    
    return results;
    
}

// returns a percentile that represents how this response compares to all others that had the same responseString. Returning 0.5, for example, means this response is the exact median for all responses.

- (double) percentileOfResponse: (NSString *) responseString versusLatency: (double) trialLatency {
    // NSNumber  *responseTime = response.response[kBTtrialLatencyKey];
    
    NSArray *allTrialsMatchingResponse = [self trialsMatchingResponse:responseString];
    
    // now count the number of items in results where the latency is higher than the current response.  Divide by the total number of items in the results.
    
    
    uint countOfItemsGreaterThanCurrentResponse = 0;
    
    for (BTDataTrial *trial in allTrialsMatchingResponse){
        
        if ([trial.trialLatency doubleValue]> trialLatency) { countOfItemsGreaterThanCurrentResponse++;
            
        }
    }
    
    double percent = (double)countOfItemsGreaterThanCurrentResponse / (double) [allTrialsMatchingResponse count];
    
    return percent;
}

- (double) recalcScoreForSession: (BTDataSession *) session {
    
    
    double newScore = 0.0;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BTDataTrial"];
    request.predicate = [NSPredicate predicateWithFormat:@"trialSessionID == %@",session.sessionID];
    
    NSError * error = nil;
    NSArray *allTrials = [self.context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"error fetching trials = %@",error.localizedDescription);
    } else
        
    {
   
        double trialPercentileTotal = 0;
        
        for (BTDataTrial *trial in allTrials){
            
            double newTrialLatency = [self percentileOfResponse:trial.trialResponseString versusLatency:[trial.trialLatency doubleValue]];
    
            trialPercentileTotal = trialPercentileTotal + newTrialLatency;
            
        }
        double newSessionScore = trialPercentileTotal / allTrials.count;
        newScore = newSessionScore;
        
       
    }
    
    return newScore;
    
}


- (IBAction)pressUpdateScores:(id)sender {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BTDataSession"];
    request.fetchLimit = 100;
    
    NSError * error = nil;
    
    NSArray *allSessions = [self.context executeFetchRequest:request error:&error];
    
    if(error){
        NSLog(@"error fetching sessions = %@",error.localizedDescription);
    } else
    {NSLog(@"Number of sessions = %lu",(unsigned long)allSessions.count);
    }
    
    for (BTDataSession *session in allSessions){
    //    NSLog(@"%@: %@",session.sessionID,session.sessionScore);
        
        double newScore = [self recalcScoreForSession:session];
        session.sessionScoreUpdated = [[NSNumber alloc] initWithDouble:newScore];
        
        NSLog(@"%@: Score (old): %0.2f, Score (new): %0.2f",session.sessionID,[session.sessionScore doubleValue], newScore);
        

        
        
    }
    
    [self updateUI];
    
   // [session updateSessionScores:self.context];
    
}

- (IBAction)sessionsOrResponsesSwitchDidChange:(id)sender {
    
    sessionsNotResponses = !sessionsNotResponses;
    [self updateSessionsOrResponsesLabel];
    [self updateUI];
    
}

#pragma mark Table Handling
// returns an item from the database and checks that it's valid

// Fetch the item at this index path, and return it as a type that is either BTDataSession or BTDataTrial, depending on the
// mode in which we are currently displaying results (as a session or as a trial/response)

- (id) itemAtIndexPath: (NSIndexPath *) indexPath {
     id item = (sessionsNotResponses) ?  (BTDataSession *)[self.fetchedResultsController objectAtIndexPath:indexPath] : [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSAssert(([item isKindOfClass:[BTDataTrial class]]|[item isKindOfClass:[BTDataSession class]]),@"Trying to show a tableview of something that isn't an expected class");

    
    if ([item isKindOfClass:[BTDataTrial class]]) { return (BTDataTrial *) item;
    }
    else{
        
        // BTDataSession *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
  //      [session updateSessionScores:self.context];
        return (BTDataSession *) item;
    
    }
    

    
}


// return either the target (i.e. ResponseString) of this item, or the comment field
// depending on which mode you're in now (session or trial/response)

- (NSString *) targetOfItem: (id) item {
    BTDataTrial *itemAsResponse;
    BTDataSession *itemAsSession;
    
    NSString *returnItem;
    
    NSAssert(([item isKindOfClass:[BTDataTrial class]]|[item isKindOfClass:[BTDataSession class]]),@"Trying to show a tableview of something that isn't an expected class (dateOfItem)");
    
    
    
    if ([item isKindOfClass:[BTDataSession class]]) {
        itemAsSession=item;
        // if you just want to display the score (i.e. the latency percentile)
       // NSNumber *scoreN = [[NSNumber alloc] initWithDouble:[itemAsSession.sessionScore doubleValue] * 1000];
       // double score = [itemAsSession.sessionScore doubleValue] * 1000;
        
        
        
       // double newScore =[self recalcScoreForSession:itemAsSession]* 100;
        NSNumber *newScoreAsNSNumber = @([itemAsSession.sessionScoreUpdated doubleValue]*100) ;
        returnItem = [[NSString alloc] initWithFormat:@" %3.1f%%",[newScoreAsNSNumber doubleValue]];
        
     //   returnItem = [[NSString alloc] initWithFormat:@" %3.1f%%",newScore];
        
        
       // returnItem= itemAsSession.sessionComment; //[scoreN stringValue];
    }
    else if ([item isKindOfClass:[BTDataTrial class]]){
        itemAsResponse = item;
        returnItem= itemAsResponse.trialResponseString;
    }
    
    return returnItem;
    
}

- (NSDate *) dateOfItem: (id) item {
    
    BTDataTrial *itemAsResponse;
    BTDataSession *itemAsSession;
    
    NSDate *returnItem;
    
     NSAssert(([item isKindOfClass:[BTDataTrial class]]|[item isKindOfClass:[BTDataSession class]]),@"Trying to show a tableview of something that isn't an expected class (dateOfItem)");
    
    
    
    if ([item isKindOfClass:[BTDataSession class]]) {
        itemAsSession=item;
        returnItem= itemAsSession.sessionDate;}
    else if ([item isKindOfClass:[BTDataTrial class]]){
        itemAsResponse = item;
        returnItem= itemAsResponse.trialTimeStamp;
    }
        
    return returnItem;
}


- (NSTimeInterval) timeOfItem: (id) item {  // this method should be called "latency" not "time"
    BTDataTrial *itemAsResponse;
    BTDataSession *itemAsSession;
    
    NSAssert(([item isKindOfClass:[BTDataTrial class]]|[item isKindOfClass:[BTDataSession class]]),@"Trying to show a tableview of something that isn't an expected class (timeOfItem)");
    
    NSTimeInterval returnItem = 0.0;
    
    if ([item isKindOfClass:[BTDataTrial class]]) {
        itemAsResponse=item;
        returnItem = (NSTimeInterval)[itemAsResponse.trialLatency doubleValue];
    }    else if ([item isKindOfClass:[BTDataSession class]]){
        itemAsSession = item;
        returnItem =  (NSTimeInterval)[itemAsSession.sessionScore doubleValue];
    }
    

    return returnItem;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
  

    [self.context deleteObject:[self itemAtIndexPath:indexPath]];
  //  [self.resultsTableView reloadData];
    [self updateUI];
    
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
    
    UILabel *cellScoreLabel = (UILabel *)[cell.contentView viewWithTag:TARGETLABELTAG];
     UILabel *cellTimeLabel = (UILabel *)[cell.contentView viewWithTag:TIMELABELTAG];
    UILabel *cellDateLabel = (UILabel *)[cell.contentView viewWithTag:DATELABELTAG];

  //  cell.textLabel.text = [self cellTextFromDouble:(double)resultTime];
  //  cell.detailTextLabel.text = [self dateText:resultDate];
    
    cellScoreLabel.text = [self targetOfItem:item];
    cellTimeLabel.text = [self cellTextFromDouble:(double)resultTime];
    cellDateLabel.text = [self dateText:resultDate];     return cell;
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
- (NSString *) cellTextFromDouble: (double) doubleToShow {
    
    NSString *cellString = (sessionsNotResponses)? [[NSString alloc]  initWithFormat:@"%3.1f%%",doubleToShow*100]: [[NSString alloc]  initWithFormat:@"%3.2f",doubleToShow*1000] ;
    return cellString;
    
}
- (NSFetchRequest *) fetchResponses {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"BTDataTrial"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kBTtrialTimestampKey ascending:NO],
                                     [NSSortDescriptor sortDescriptorWithKey: kBTtrialLatencyKey ascending:YES]];
    
    return fetchRequest;
    
}

- (NSFetchRequest *) fetchSessions {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"BTDataSession"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sessionDate" ascending:NO],
                                     [NSSortDescriptor sortDescriptorWithKey: @"sessionScore" ascending:YES]];
    
    return fetchRequest;
    
}

- (void) updateSessionsOrResponsesLabel {
    
    self.sessionsOrResponsesLabel.text = (sessionsNotResponses) ? @"Sessions" : @"Trials";
    self.sessionsOrSecondsLabel.text = (sessionsNotResponses) ?@"Percentile" : @"ms";
    self.targetOrRoundsLabel.text =(sessionsNotResponses) ?@"Rounds" : @"Target";
    
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
   // NSLog(@"reloading data for Results tab display");
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    //   NSManagedObjectContext *context = [self managedObjectContext];
    if (!self.context){self.context = [self managedObjectContext];
        
    }

    [self updateSessionsOrResponsesLabel];

        [self updateUI];
 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (!self.context){self.context = [self managedObjectContext];
        
    }
    sessionsNotResponses = YES;
    
   [self updateUI];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
