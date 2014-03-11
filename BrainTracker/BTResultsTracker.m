//
//  BTResultsTracker.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTResultsTracker.h"
#import "BTData.h"

@interface BTResultsTracker ()

@property (strong, nonatomic) NSManagedObjectContext *context;



@end

@implementation BTResultsTracker

//@synthesize responses;



// returns a percentile that represents how this response compares to all others that had the same responseString. Returning 0.5, for example, means this response is the exact median for all responses.

- (double) percentileOfResponse: (BTResponse *) response {
    NSString *responseString =response.response[KEY_RESPONSE_STRING];
    NSNumber  *responseTime = response.response[KEY_RESPONSE_TIME];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BTData"];
    
    // filter for everything in the database where attribute ResponseString = responseString
    NSPredicate *matchesString = [NSPredicate predicateWithFormat:@"%K matches %@",@"responseString",responseString];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:KEY_RESPONSE_TIME ascending:YES]];
    
    [request setPredicate:matchesString];

    
    NSError *error ;
    NSArray *results = [self.context executeFetchRequest:request error:&error  ];
    
    NSMutableArray *responseTimes = [[NSMutableArray alloc] init];
    for (BTData *result in results) {
        
        
        NSTimeInterval rt = [result.responseTime doubleValue];
        [responseTimes addObject:result.responseTime];
        
        
        NSLog(@"result=%@,%f",result.responseString,rt);
        
        //
        
    }
    
    NSExpression *expression = [NSExpression expressionForFunction:@"median:" arguments:@[[NSExpression expressionForConstantValue:responseTimes]]];
    
   id value = [expression expressionValueWithObject:nil context:nil];
    
    double MedianVal = [value doubleValue];
    
    uint g= 0;
    uint rc=[responseTimes count];
    
    for (uint i = 0; i<rc;i++){
        if ([responseTimes[i] doubleValue]>=MedianVal) {NSLog(@"MedianVal=%f, g=%d",MedianVal,i); g=i;break;}
        else {NSLog(@"i=%f",[responseTimes[i] doubleValue]);}
    }
    
    //double percent = 55.0;
    double percent = (double)g/(double)rc;
    
    return percent;
}


- (void) saveResult: (BTResponse *) response {
    
  
    NSString *responseString =response.response[KEY_RESPONSE_STRING];
    NSDate *responseDate = response.response[KEY_RESPONSE_DATE];
    NSNumber  *responseTime = response.response[KEY_RESPONSE_TIME];
    
 //   [self.responses addObject:@{KEY_RESPONSE_STRING:responseString, KEY_RESPONSE_DATE:responseDate,KEY_RESPONSE_TIME:responseTime}];

    
    if (!self.context) {NSLog(@"no context found in BTResultsTracker.saveResult");}
    else {
        // think of this like a proxy for a response item in the database
        BTData *BTDataResponse =[NSEntityDescription insertNewObjectForEntityForName:@"BTData" inManagedObjectContext:self.context];
        
 
//    NSManagedObject *newDbResponseRecord = [NSEntityDescription insertNewObjectForEntityForName:@"BTData" inManagedObjectContext:self.context];
//    [newDbResponseRecord setValue:responseString forKey:KEY_RESPONSE_STRING];
//    [newDbResponseRecord setValue:responseTime forKey:KEY_RESPONSE_TIME];
//    [newDbResponseRecord setValue:responseDate forKey:KEY_RESPONSE_DATE];
        
        BTDataResponse.responseTime = responseTime;
        BTDataResponse.responseString = responseString;
        BTDataResponse.responseDate = responseDate;
        
    }
    
}
//
//- (BTResponse *) latestResponse { // returns latest response on file
//    
//    return [self.responses lastObject];
//
//}



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



    
//    if (!self.responses) { // no responses have been received yet.  Obviously a new user, so set up a new response array
//    
//        NSLog(@"FIRST TIME USER...set up resultsTracker");// [[NSUserDefaults standardUserDefaults] ]
//        self.responses = [[NSMutableArray alloc] init];
    
        // now you can add to self.responses array without worrying that it's not initialized.
        
        
    //}  // otherwise just use the array you got back from KEY_FOR_RESPONSES
    
    
    
    return self;
    
    
    
}


@end
