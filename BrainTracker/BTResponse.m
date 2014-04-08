//
//  BTResponse.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTResponse.h"

@interface BTResponse()



@end

NSString * const kBTResponseStringKey = @"responseString";
NSString * const kBTResponseTimeKey = @"responseTime";
NSString * const kBTResponseDateKey = @"responseDate";


@implementation BTResponse


- (BOOL) matchesResponse: (BTResponse *) otherResponse {
    
    
    if ([otherResponse.response[kBTResponseStringKey] isEqualToString:[self.response objectForKey:kBTResponseStringKey]])
        return YES;
    else return NO;
        
        
}


- (NSTimeInterval) responseTime {
    
    NSNumber * rt = [self valueForKey:kBTResponseTimeKey];
    
    if (!rt){
        NSLog(@"Error: responseTime not defined");
        return 0.0;
    } else
    return [rt doubleValue];
}

- (NSString *) responseLabel {
    
    NSString *idLabel = [self.response objectForKey:kBTResponseStringKey];
    return idLabel;
    
}



- (void) setResponseTime: (NSTimeInterval ) timeInSeconds {
    

    
    [self.response setValue:[NSNumber numberWithDouble:timeInSeconds] forKey:kBTResponseTimeKey];
    [self.response setValue:[NSDate date] forKey:kBTResponseDateKey];
}



- (id) initWithString: (NSString *) initString {
    
    self = [super init];
    
    
        _response = [[NSMutableDictionary alloc] initWithObjectsAndKeys:initString,kBTResponseStringKey, nil];
    
    
    return  self;
    
    
}


@end
