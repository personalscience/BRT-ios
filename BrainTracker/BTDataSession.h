//
//  BTDataSession.h
//  BrainTracker
//
//  Created by Richard Sprague on 9/26/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BTDataTrial;

@interface BTDataSession : NSManagedObject

@property (nonatomic, retain) NSString * sessionComment;
@property (nonatomic, retain) NSDate * sessionDate;
@property (nonatomic, retain) NSString * sessionID;
@property (nonatomic, retain) NSNumber * sessionRounds;
@property (nonatomic, retain) NSNumber * sessionScore;
@property (nonatomic, retain) NSNumber * sessionScoreUpdated;
@property (nonatomic, retain) NSSet *whichTrials;
@end

@interface BTDataSession (CoreDataGeneratedAccessors)

- (void)addWhichTrialsObject:(BTDataTrial *)value;
- (void)removeWhichTrialsObject:(BTDataTrial *)value;
- (void)addWhichTrials:(NSSet *)values;
- (void)removeWhichTrials:(NSSet *)values;

@end
