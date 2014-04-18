//
//  BTResultsTracker.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTResultsTracker.h"
#import "BTData.h"
#import "BTDataSession.h"

@interface BTResultsTracker ()

@property (strong, nonatomic) NSManagedObjectContext *context;



@end

@implementation BTResultsTracker


// returns a percentile that represents how this response compares to all others that had the same responseString. Returning 0.5, for example, means this response is the exact median for all responses.

- (double) percentileOfResponse: (BTResponse *) response {
    NSString *responseString =response.response[kBTResponseStringKey];
    NSNumber  *responseTime = response.response[kBTResponseTimeKey];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BTData"];
    
    // filter for everything in the database where attribute ResponseString = responseString
    NSPredicate *matchesString = [NSPredicate predicateWithFormat:@"%K matches %@",kBTResponseStringKey,responseString];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kBTResponseTimeKey ascending:YES]];
    
    [request setPredicate:matchesString];

    
    NSError *error ;
    NSArray *results = [self.context executeFetchRequest:request error:&error  ];
    // results is an NSArray of every response that matched this stimulus
    
    NSMutableArray *responseTimes = [[NSMutableArray alloc] init];
    for (BTData *result in results) {
        
        
 //       NSTimeInterval rt = [result.responseTime doubleValue];
        [responseTimes addObject:result.responseTime];
        
        
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
        if ([responseTimes[i] doubleValue]>=[responseTime doubleValue]) {
  //          NSLog(@"Count = %d, MedianVal=%f, rt[%d]=%0.3f",rc, MedianVal,i,[responseTimes[i] doubleValue]);
            g=i;break;
        }
  //      else {NSLog(@"i=%f",[responseTimes[i] doubleValue]);}
    } // after going through this loop, g = the number of sorted times in the array that are less than or equal to responseTime
    
    //double percent = 55.0;
    double percent = (double)g/(double)rc;
    
    return percent;
}

- (void) saveSession: (BTDataSession *) session {
    if (!self.context) {NSLog(@"no context found in BTResultsTracker.saveResult");}
    else {
        // think of this like a proxy for a response item in the database
        BTDataSession *BTDataResponse =[NSEntityDescription insertNewObjectForEntityForName:@"BTDataSession" inManagedObjectContext:self.context];

        
    }
    
}

- (void) saveResult: (BTResponse *) response {
    
  
    NSString *responseString =response.response[kBTResponseStringKey];
    NSDate *responseDate = response.response[kBTResponseDateKey];
    NSNumber  *responseTime = response.response[kBTResponseTimeKey];
    
 //   [self.responses addObject:@{KEY_RESPONSE_STRING:responseString, KEY_RESPONSE_DATE:responseDate,KEY_RESPONSE_TIME:responseTime}];

    
    if (!self.context) {NSLog(@"no context found in BTResultsTracker.saveResult");}
    else {
        // think of this like a proxy for a response item in the database
        BTData *BTDataResponse =[NSEntityDescription insertNewObjectForEntityForName:@"BTData" inManagedObjectContext:self.context];
        
        BTDataResponse.responseTime = responseTime;
        BTDataResponse.responseString = responseString;
        BTDataResponse.responseDate = responseDate;
        
    }
    [self saveToDisk:responseString duration:[responseTime doubleValue] comment:@"empty comment here"];
}



-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"BrainTrackerResultsFile.csv"];
}

- (void) saveToDisk: (NSString *) inputString  duration: (NSTimeInterval) duration comment: (NSString *) comment{
    
    NSString *textToWrite = [[NSString alloc] initWithFormat:@"%@,%@,%f,%@\n",[NSDate date], inputString,duration,comment];
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
        NSString *textToWrite = [[NSString alloc] initWithFormat:@"date,string,time,comment\n"];
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



    
//    if (!self.responses) { // no responses have been received yet.  Obviously a new user, so set up a new response array
//    
//        NSLog(@"FIRST TIME USER...set up resultsTracker");// [[NSUserDefaults standardUserDefaults] ]
//        self.responses = [[NSMutableArray alloc] init];
    
        // now you can add to self.responses array without worrying that it's not initialized.
        
        
    //}  // otherwise just use the array you got back from KEY_FOR_RESPONSES
    
    
    
    return self;
    
    
    
}


@end
