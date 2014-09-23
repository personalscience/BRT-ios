//
//  BTSession.m
//  BrainTracker
//
//  Created by Richard Sprague on 5/24/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTSession.h"

@implementation BTSession


- (id) initWithComment: (NSString *) comment {
    
    self = [super init];
    
    _sessionComment = comment;
    _sessionDate = [NSDate date];
    _sessionRounds = [[NSUserDefaults standardUserDefaults] objectForKey:kBTMaxTrialsPerSessionKey];
    
    return self;
    
}

@end
