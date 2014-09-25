//
//  BTDataTrial.h
//  BrainTracker
//
//  Created by Richard Sprague on 9/23/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BTDataSession;

@interface BTDataTrial : NSManagedObject

@property (nonatomic, retain) NSNumber * trialForeperiod;
@property (nonatomic, retain) NSNumber * trialLatency;
@property (nonatomic, retain) NSString * trialResponseString;
@property (nonatomic, retain) NSString * trialSessionID;
@property (nonatomic, retain) NSString * trialStimulusString;
@property (nonatomic, retain) NSDate * trialTimeStamp;
@property (nonatomic, retain) BTDataSession *whichSession;

@end
