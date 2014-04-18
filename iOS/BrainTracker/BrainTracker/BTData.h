//
//  BTData.h
//  BrainTracker
//
//  Created by Richard Sprague on 4/9/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BTDataSession;

@interface BTData : NSManagedObject

@property (nonatomic, retain) NSDate * responseDate;
@property (nonatomic, retain) NSString * responseString;
@property (nonatomic, retain) NSNumber * responseTime;
@property (nonatomic, retain) NSNumber * responseLocation;
@property (nonatomic, retain) NSNumber * responseTravel;
@property (nonatomic, retain) NSDate * responseSession;
@property (nonatomic, retain) BTDataSession *whichSession;

@end
