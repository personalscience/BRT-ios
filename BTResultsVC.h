//
//  BTResultsVC.h
//  BrainTracker
//
//  Created by Richard Sprague on 3/7/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
// Displays results (either Sessions and Responses) in a UITableView

#import <UIKit/UIKit.h>

// values set in BTResponse.m

extern NSString * const kBTtrialResponseStringKey;
extern NSString * const kBTtrialLatencyKey;
extern NSString * const kBTtrialTimestampKey;

@interface BTResultsVC : UIViewController

@end
