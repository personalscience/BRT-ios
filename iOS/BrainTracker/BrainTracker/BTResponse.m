//
//  BTResponse.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTResponse.h"

@interface BTResponse()
//@property (nonatomic,strong) NSMutableDictionary *response;
//
//@property (strong, nonatomic) NSString *responseString;


@end

@implementation BTResponse


- (BOOL) matchesResponse: (BTResponse *) otherResponse {
    
    
    if ([otherResponse.response[KEY_RESPONSE_STRING] isEqualToString:[self.response objectForKey:KEY_RESPONSE_STRING]])
        return YES;
    else return NO;
        
        
}

//- (NSDictionary *) response {
//    if (!_response) {
//        NSLog(@"trying to get 'response' without a value");
//        return nil;
//    }
//    else {
//        return _response;
//    }
//    
//}

- (NSTimeInterval) responseTime {
    
    NSNumber * rt = [self valueForKey:KEY_RESPONSE_TIME];
    
    if (!rt){
        NSLog(@"Error: responseTime not defined");
        return 0.0;
    } else
    return [rt doubleValue];
}


- (void) setResponseTime: (NSTimeInterval ) timeInSeconds {
    
//    _responseTime = timeInSeconds;
//    [self.response setValue:[NSNumber numberWithDouble:timeInSeconds] forKey:KEY_RESPONSE_TIME];
//    [self.response setValue:[NSDate date] forKey:KEY_RESPONSE_DATE];
    
    [self.response setValue:[NSNumber numberWithDouble:timeInSeconds] forKey:KEY_RESPONSE_TIME];
    [self.response setValue:[NSDate date] forKey:KEY_RESPONSE_DATE];
}



- (id) initWithString: (NSString *) initString {
    
    self = [super init];
    
 //   self.responseString = initString;
    
        self.response = [[NSMutableDictionary alloc] initWithObjectsAndKeys:initString,KEY_RESPONSE_STRING, nil];
    
    
    return  self;
    
    
}


@end
