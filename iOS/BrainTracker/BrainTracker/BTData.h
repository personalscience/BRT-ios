//
//  BTData.h
//  BrainTracker
//
//  Created by Richard Sprague on 3/10/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BTData : NSManagedObject

@property (nonatomic, retain) NSDate * responseDate;
@property (nonatomic, retain) NSString * responseString;
@property (nonatomic, retain) NSNumber * responseTime;

@end
