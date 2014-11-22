//
//  BTFileReader.m
//  BrainTracker
//
//  Created by Richard Sprague on 9/24/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTFileReader.h"
#import "BTDataSession.h"
#import "BTDataTrial.h"

@interface BTFileReader()

@property (strong, nonatomic) NSManagedObjectContext *context;


@end

//NSString * const kBTMaxTrialsPerSessionKey = @"trialsPerSession";

@implementation BTFileReader


- (void) readFromDisk: (NSString *) dataFilePath {
  
    
        
        NSError *error;
        
        NSString *fileContents = [[NSString alloc] initWithContentsOfFile:dataFilePath encoding:NSASCIIStringEncoding error:&error];
        
        if(error) {NSLog(@"couldn't get components of CSV file");
        }else {
            
            
            
            NSArray *allLinesInFile = [fileContents componentsSeparatedByString:@"\r"];
   //         NSString *csvFileHeader = allLinesInFile[0];
            
            NSRange rangeForFile = NSMakeRange(1,[allLinesInFile count]-2);
            
            NSArray *linesInFile = [allLinesInFile subarrayWithRange:rangeForFile];
            
            NSAssert(rangeForFile.length>1,@"CSV file is not greater than one line");
            
            NSString *currentSessionID = @"NOSESSION";
            
            int trialNumber = 1;
            
            for (NSString *eachLineInFile in linesInFile){
                NSArray *valuesInLine = [eachLineInFile componentsSeparatedByString:@","];
               
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
                
                NSString *valueSessionID = valuesInLine[0];
 
                
                NSDate *valueDate = [dateFormatter dateFromString:valuesInLine[1]]; //@"2014-09-05 19:28:40 +0000"]; // //];  //[NSDate date]; //[dateFormatter dateFromString:valuesInLine[0]];  //[dateFormatter dateFromString:valuesInLine[0]];
                
                NSString *valueString = valuesInLine[2];
                
                NSNumber *valueLatency = [[[NSNumberFormatter alloc] init] numberFromString:valuesInLine[3]];
                NSNumber *valueLatencyMsec = [NSNumber numberWithDouble:([valueLatency doubleValue] / 1000)] ;
                
                
                
                
                NSString *valueComment = valuesInLine[4];
                
                
                if ([valueString isEqualToString:@"Session"]) {
                    NSLog(@"Session Results = %@",valueLatency);
                    NSLog(@"comment=%@",valueComment);
                    BTDataSession *newSession =[NSEntityDescription insertNewObjectForEntityForName:@"BTDataSession" inManagedObjectContext:[self managedObjectContext]];
                    
                    newSession.sessionDate = valueDate;
                    
                    trialNumber = trialNumber - 1;// because it was incremented after the last trial was read
                    
                    NSLog(@"session rounds=%d",trialNumber);
                    
                    newSession.sessionRounds = [[NSNumber alloc]initWithInt:trialNumber];
        
                    
                    
                    newSession.sessionScore = valueLatency;
                    newSession.sessionID = currentSessionID; // Note: uses the previous trial session ID, so the entire CSV file must be in order: session follows trial
                    newSession.sessionComment = [[NSString alloc] initWithFormat:@"%@",valueComment];
                    
                    trialNumber = 1;
                    
                } else {
                    NSLog(@"date=%@",valueDate);
                    NSLog(@"string=%@",valueString);
                    NSLog(@"latency=%f",[valueLatencyMsec doubleValue]);
                    
                                   currentSessionID = valueSessionID;
                    
                    BTDataTrial *newTrial = [NSEntityDescription insertNewObjectForEntityForName:@"BTDataTrial" inManagedObjectContext:[self managedObjectContext]];
                    
                    newTrial.trialSessionID = valueSessionID;
                    newTrial.trialLatency = valueLatencyMsec;
                    newTrial.trialResponseString = valueString;
                    newTrial.trialStimulusString = valueString;
                    newTrial.trialTimeStamp = valueDate;
                    newTrial.trialNumber = [[NSNumber alloc] initWithInt:trialNumber];
                    newTrial.trialInclude = @1;
                    newTrial.trialCorrect = @1;
                    trialNumber++;
                    
                }
                //        
                //        
                //        for (NSString *oneCSVValue in valuesInLine) {
                //            
                //      
                //            NSLog(@"(%@)",oneCSVValue);
                //            
                //    }
                NSLog(@"\n");
                
                
            }}

}
    
    
    


- (NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    
    return context;
}


@end
