//
//  BTDataSession.h
//  BrainTracker
//
//  Created by Richard Sprague on 4/9/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/*
Database nomenclature consistent with Seth’s program


   * Trial: includes
   * 
      * stimulus == problem (e.g. "showed ball number 6”)
      * response == actual.answer (e.g. "tapped the wrong location”, “hit ball number 6”)
      * latency == latency.msec (difference in time between when the stimulus was presented and when the response was received)
      * timestamp == when  (the time at which the stimulus was presented)
      * session == condition (unique identifier that applies to all trials in a particular session)
      * foreperiod (how long between warning the user and first presentation of the stimulus)
      * whichSession: one-to-one pointer to a session to which this trial belongs.
   * Session: 
   * 
      * whichTrial: one-to-many pointer to set of trials associated with this session
      * sessionRounds: number of rounds expected for this session
      * sessionID: (unique identifier that applies to all trials in this session)
      * SessionDate: a timestamp applied when the session is finished. 
*/

@class BTDataTrial;

@interface BTDataSession : NSManagedObject

@property (nonatomic, retain) NSDate * sessionDate;
@property (nonatomic, retain) NSString * sessionComment;
@property (nonatomic, retain) NSNumber * sessionScore;  // a percentile, value from 0.0 to 1.0
@property (nonatomic, retain) NSNumber * sessionRounds; // integer number of rounds in this session
@property (nonatomic, retain) BTDataTrial *whichResponse;

@end
