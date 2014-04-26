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

// convoluted way of saying that the responseString is @0, which means that yes, this is a "stimulus" aka it's the start button.
- (BOOL) isStimulus {
//    
//    NSString *id = self.response[kBTResponseStringKey];
//    if(id){
//        // yes, there's a responseStringKey in here
//        if ([id isKindOfClass:[NSString class]]){
//            // yes, it's a string
//            NSNumber *num = [[[NSNumberFormatter alloc] init] numberFromString:id];
//            if ([num compare:@0] == NSOrderedSame){
//                // this response string = 0, so yes it's a Stimulus
//                return YES;
//            } else return NO;
//        } else return NO;
//    } else return NO;
    
    if ([self.idNum isEqualToNumber:@0]){
        return YES;
    } else return NO;
}


- (NSTimeInterval) responseTime {
    
    NSNumber * rt = [self.response valueForKey:kBTResponseTimeKey];
    
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

- (NSNumber *) idNum {
    
    NSNumber *idNum = @0; // default id returned is 0.
    
    NSString *id = self.response[kBTResponseStringKey];
    if(id){
        // yes, there's a responseStringKey in here
        if ([id isKindOfClass:[NSString class]]){
            // yes, it's a string
           idNum = [[[NSNumberFormatter alloc] init] numberFromString:id];
        } else NSLog(@"bad ID for responseString %@",self.response.description);
    }else NSLog(@"missing responseString %@",self.response.description);
    
    return idNum;
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
