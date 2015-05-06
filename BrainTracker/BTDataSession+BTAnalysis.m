//
//  BTDataSession+BTAnalysis.m
//  BrainTracker
//
//  Created by Richard Sprague on 9/23/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTDataSession+BTAnalysis.h"
#import "BTDataTrial.h"

const NSString *kBTTrialSessionIDkey = @"sessionID";
//extern NSString *kBTtrialTimestampKey;
//extern int kBTlastNTrialsCutoffValue;


@implementation BTDataSession (BTAnalysis)

    


- (NSArray *) allSessions: (NSManagedObjectContext *) context {
    
    // returns an array of all sessions
   
    
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BTDataTrial" ];
        
        // filter for everything in the database where attribute ResponseString = responseString
        NSPredicate *matchesString = [NSPredicate predicateWithFormat:@"ALL %K",kBTTrialSessionIDkey];
        
        //   request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kBTtrialLatencyKey ascending:NO]];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kBTtrialTimestampKey ascending:NO]];
        
        // I can just grab the first n responses with this:
        request.fetchLimit = kBTlastNTrialsCutoffValue;
        
        
        
        [request setPredicate:matchesString];
        
        
        NSError *error ;
        NSArray *results = [context executeFetchRequest:request error:&error  ];
        
        NSAssert(!error, @"error fetching trials to match response: (%@) : %@",kBTTrialSessionIDkey,[error localizedDescription]);
        
        // results is an NSArray of every response that matched this stimulus
        
        return results;
        
}

-  (NSArray *) allTrialsMatchingSessionID: (NSString *) sessionID withContext: (NSManagedObjectContext *) context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BTDataTrial" ];
    
    // filter for everything in the database where attribute
    NSPredicate *matchesString = [NSPredicate predicateWithFormat:@"ALL %K",kBTTrialSessionIDkey];
    
    //   request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kBTtrialLatencyKey ascending:NO]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kBTtrialTimestampKey ascending:NO]];
    
    // I can just grab the first n responses with this:
    request.fetchLimit = kBTlastNTrialsCutoffValue;
    
    
    
    [request setPredicate:matchesString];
    
    
    NSError *error ;
    NSArray *results = [context executeFetchRequest:request error:&error  ];
    
    NSAssert(!error, @"error fetching trials to match response: (%@) : %@",kBTTrialSessionIDkey,[error localizedDescription]);
    
    // results is an NSArray of every response that matched this stimulus
    
    return results;
  
    
}

- (double) percentileOfTrial: (BTDataTrial *) trial withContext:(NSManagedObjectContext *) context {
    // NSNumber  *responseTime = response.response[kBTtrialLatencyKey];
    
    NSArray *allTrials = [self allTrialsMatchingSessionID:trial.trialSessionID withContext:context];
    
    // now count the number of items in results where the latency is higher than the current response.  Divide by the total number of items in the results.
    
    
    uint countOfItemsGreaterThanCurrentResponse = 0;
    
    for (BTDataTrial *oneTrial in allTrials){
        
        if ([oneTrial.trialLatency doubleValue]> [trial.trialLatency doubleValue]) { countOfItemsGreaterThanCurrentResponse++;
            
        }
    }
    
    double percent = (double)countOfItemsGreaterThanCurrentResponse / (double) [allTrials count];
 
    return percent;
}

- (void) updateSessionScores: (NSManagedObjectContext *) context {
    
    NSArray *allSessions = [self allSessions:context];
    
    
    for (BTDataSession *session in allSessions ){
        
        NSArray *trialsMatchingSessionID = [self allTrialsMatchingSessionID:session.sessionID withContext: context];
        
        for (BTDataTrial *trial in trialsMatchingSessionID) {
            
            
            double rollingMatchingPercentile = [self percentileOfTrial:trial withContext:context];
            NSLog(@"Trial %@ %%=%f ",trial.trialSessionID, rollingMatchingPercentile);
            
        }
      
        
        
    }
    
}

@end
