//
//  BTSession.m
//  BrainTracker
//
//  Created by Richard Sprague on 5/24/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTSession.h"

@implementation BTSession
extern NSString * const kBTMaxTrialsPerSessionKey;

- (id) initWithComment: (NSString *) comment {
    
    self = [super init];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
   // [format setDateStyle:NSDateFormatterShortStyle];
    //[format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateFormat:@"YYYYMMDDHHmm"];
    
    _sessionComment = comment;
    _sessionDate = [NSDate date];
    _sessionID = [NSString localizedStringWithFormat:@"ID%@|%@",_sessionComment,[format stringFromDate:_sessionDate]];
    _sessionRounds = [[NSUserDefaults standardUserDefaults] objectForKey:kBTMaxTrialsPerSessionKey];
    
    return self;
    
}

@end
