//
//  BTResultsTracker.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTResultsTracker.h"
#import "BTDataTrial.h"
#import "BTTrial.h"
#import "BTDataSession.h"
#import "BTResponse.h"
#import "BTSession.h"


@interface BTResultsTracker ()

@property (strong, nonatomic) NSManagedObjectContext *context;


@end

int const kBTlastNTrialsCutoffValue = 100;

@implementation BTResultsTracker

- (BOOL) isUnderCutOff: (NSTimeInterval)  responseLatency {
    if (responseLatency <= kBTLatencyCutOffValue)
        
        return YES;
    else return NO;
    
}



// returns an array of trials whose trialResponseString equals the string in response.
// The array is sorted by date, from highest to lowest.  
- (NSArray *) trialsMatchingResponse: (BTResponse *) response {
    NSString *responseString =response.response[kBTtrialResponseStringKey];
  //  NSNumber  *responseTime = response.response[kBTtrialLatencyKey];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BTDataTrial" ];
  
    // filter for everything in the database where attribute ResponseString = responseString
    NSPredicate *matchesString = [NSPredicate predicateWithFormat:@"%K matches %@",kBTtrialResponseStringKey,responseString];
    
 //   request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kBTtrialLatencyKey ascending:NO]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kBTtrialTimestampKey ascending:NO]];
    
    // I can just grab the first n responses with this:
    request.fetchLimit = kBTlastNTrialsCutoffValue;

    
    
    [request setPredicate:matchesString];
    
    
    NSError *error ;
    NSArray *results = [self.context executeFetchRequest:request error:&error  ];
    
    NSAssert(!error, @"error fetching trials to match response: (%@) : %@",responseString,[error localizedDescription]);
    
    // results is an NSArray of every response that matched this stimulus
    
    return results;
    
}

// returns a percentile that represents how this response compares to all others that had the same responseString. Returning 0.5, for example, means this response is the exact median for all responses.

- (double) percentileOfResponse: (BTResponse *) response {
    // NSNumber  *responseTime = response.response[kBTtrialLatencyKey];
    
    NSArray *results = [self trialsMatchingResponse:response];
    
    // now count the number of items in results where the latency is higher than the current response.  Divide by the total number of items in the results.
    
    
    uint countOfItemsGreaterThanCurrentResponse = 0;
    
    for (BTDataTrial *result in results){
        
        if ([result.trialLatency doubleValue]> response.responseLatency) { countOfItemsGreaterThanCurrentResponse++;
            
        }
    }
    
    double percent = (double)countOfItemsGreaterThanCurrentResponse / (double) [results count];
    
/* old convoluted way of calculating the percentile involved sorting the array and walking through it till you reach the median
    // results is a sorted NSArray of every response that matched this stimulus
    
    NSMutableArray *responseTimes = [[NSMutableArray alloc] init];
    for (BTDataTrial *result in results) {
        
        
 //       NSTimeInterval rt = [result.responseTime doubleValue];
        [responseTimes addObject:result.trialLatency];
        
        
  //      NSLog(@"result=%@,%f",result.responseString,rt);
        
        //
        
    }
    
    // responseTimes now is an NSMutableArray with just the times in it.
    
     NSExpression *expression = [NSExpression expressionForFunction:@"median:" arguments:@[[NSExpression expressionForConstantValue:responseTimes]]];
    
    NSNumber *value;
    if ([responseTimes count]>0){
            value = [expression expressionValueWithObject:nil context:nil];
    } else value = @0.0f;
    
    // this is the median value of all the items (i.e. response times) in the responseTimes array.
    
  //  double MedianVal = [value doubleValue];
    
  //  NSLog(@"responseTime=%0.3f",[responseTime doubleValue]);
    
    uint g= 0;
    uint rc=(uint)[responseTimes count] ;
    
    for (uint i = 0; i<rc;i++){
        if ([responseTimes[i] doubleValue]<=[responseTime doubleValue]) {
  //          NSLog(@"Count = %d, MedianVal=%f, rt[%d]=%0.3f",rc, MedianVal,i,[responseTimes[i] doubleValue]);
            g=i;break;
        }
  //      else {NSLog(@"i=%f",[responseTimes[i] doubleValue]);}
    } // after going through this loop, g = the number of sorted times in the array that are less than or equal to responseTime
    
    //double percent = 55.0;
    double percent = (double)g/(double)rc;
    
    
*/
    
    return percent;
}

// stores the current session to the BTDataSession store, and also to a CSV on disk
// 
- (void) saveSession: (BTSession *) session {
    if (!self.context) {NSLog(@"no context found in BTResultsTracker.saveResult");}
    else {
        // think of this like a proxy for a session item in the database
        BTDataSession *newSession =[NSEntityDescription insertNewObjectForEntityForName:@"BTDataSession" inManagedObjectContext:self.context];
        newSession.sessionDate = session.sessionDate;
        newSession.sessionRounds = session.sessionRounds;
        newSession.sessionScore = session.sessionScore;
        
        [self saveToDisk:@"Session" duration:[session.sessionScore doubleValue] comment:session.sessionComment];
        NSLog(@"saved session with results=%f",[session.sessionScore doubleValue]);
        
    }
    
}

# pragma mark Disk Save

- (void) saveTrial:(BTTrial *)trial  {
    
    if (!self.context) {NSLog(@"no context found in BTResultsTracker.saveResult");}
    else {
        // think of this like a proxy for a response item in the database
        
        //* UNCOMMMENT THIS WHEN YOU ARE READY TO SAVE TO DATABASE
        BTDataTrial *BTDataResponse =[NSEntityDescription insertNewObjectForEntityForName:@"BTDataTrial" inManagedObjectContext:self.context];
        
        BTDataResponse.trialLatency = trial.trialLatency;
        BTDataResponse.trialResponseString = trial.trialResponseString;
        BTDataResponse.trialTimeStamp = trial.trialTimeStamp;
        BTDataResponse.trialSessionID = trial.trialSessionID;
        BTDataResponse.whichSession = trial.trialSession;
        
        
        // */
        
    }
    NSString *textToWrite = [[NSString alloc] initWithFormat:@"(timestamp=%@),%@,%f,%@\r",trial.trialTimeStamp, trial.trialResponseString,[trial.trialLatency doubleValue]*1000,trial.trialSession.sessionComment];
    NSLog(@"Disk Save:\n%@\n",textToWrite);
    
    [self saveToDisk:textToWrite];

    
}


/* deprecated on 9/23; use saveTrial instead
- (void) saveResult: (BTResponse *) response {
    
  
    NSString *responseString =response.response[kBTtrialResponseStringKey];
    NSDate *responseDate = response.response[kBTtrialTimestampKey];
    NSNumber  *responseTime = response.response[kBTtrialLatencyKey];
    
 //   [self.responses addObject:@{KEY_RESPONSE_STRING:responseString, KEY_RESPONSE_DATE:responseDate,KEY_RESPONSE_TIME:responseTime}];

    
    if (!self.context) {NSLog(@"no context found in BTResultsTracker.saveResult");}
    else {
        // think of this like a proxy for a response item in the database
        BTDataTrial *BTDataResponse =[NSEntityDescription insertNewObjectForEntityForName:@"BTDataTrial" inManagedObjectContext:self.context];
        
        BTDataResponse.trialLatency = responseTime;
        BTDataResponse.trialResponseString = responseString;
        BTDataResponse.trialTimeStamp = responseDate;
        
    }
    [self saveToDisk:responseString duration:[responseTime doubleValue]*1000 comment:[[NSString alloc] initWithFormat: @"Target Response=%@",responseString]];
}

*/

-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"BrainTrackerResultsFile.csv"];
}

- (void) saveToDisk: (NSString *) textToWrite {
    
   // NSString *textToWrite = [[NSString alloc] initWithFormat:@"%@,%@,%f,%@\r",[NSDate date], inputString,duration,comment];
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
    //say to handle where's the file fo write
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    //position handle cursor to the end of file
    [handle writeData:[textToWrite dataUsingEncoding:NSUTF8StringEncoding]];
    
}

- (void) saveToDisk: (NSString *) inputString  duration: (NSTimeInterval) duration comment: (NSString *) comment{
    
    NSString *textToWrite = [[NSString alloc] initWithFormat:@"%@,%@,%f,%@\r",[NSDate date], inputString,duration,comment];
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
    //say to handle where's the file fo write
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    //position handle cursor to the end of file
    [handle writeData:[textToWrite dataUsingEncoding:NSUTF8StringEncoding]];
    
}

- (void) doInitializationsIfNecessary {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
        NSLog(@"new results file created");
        NSString *textToWrite = [[NSString alloc] initWithFormat:@"date,string,latency (mSec),comment\r"];
        NSFileHandle *handle;
        handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
        //say to handle where's the file fo write
        //       [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        //position handle cursor to the end of file
        [handle writeData:[textToWrite dataUsingEncoding:NSUTF8StringEncoding]];
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

- (id) init {
    
    self = [super init];
    
/* First, get the managedObjectContext for this instance */
    
    self.context = [self managedObjectContext];
    [self doInitializationsIfNecessary];
    
    if(kBTLatencyCutOffValue==0) {kBTLatencyCutOffValue=3.0;} // initialization:  this should be deleted in final version



    
//    if (!self.responses) { // no responses have been received yet.  Obviously a new user, so set up a new response array
//    
//        NSLog(@"FIRST TIME USER...set up resultsTracker");// [[NSUserDefaults standardUserDefaults] ]
//        self.responses = [[NSMutableArray alloc] init];
    
        // now you can add to self.responses array without worrying that it's not initialized.
        
        
    //}  // otherwise just use the array you got back from KEY_FOR_RESPONSES
    
    
    
    return self;
    
    
    
}


@end
