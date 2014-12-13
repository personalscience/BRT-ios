//
//  ZBConnection.m
//  BrainTracker
//
//  Created by Richard Sprague on 12/12/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "ZBConnection.h"

@implementation ZBConnection



//Initializing this class sets it up with the access token and ID string you pre-registered in NSUserDefaults.
// if there are no access strings in NSUserDefaults, you should go prompt the user.

- (id) init {
    
    self = [super init];
    
    self.ZBAccessTokenString = [[NSString alloc] initWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:ZBACCESSTOKEN_KEY]] ;
    self.ZBClientIDString = [[NSString alloc] initWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:ZBCLIENTID_KEY]] ;
    self.ZBScopeTokenString = [[NSString alloc] initWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:ZBSCOPETOKEN_KEY]] ;
    
    return self;
    
}

- (void) getZBAccessTokenForUsername:(NSString *)username withPassword:(NSString *)password {
    NSURL *url  = [NSURL URLWithString:@"https://api.zenobase.com/oauth/token"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"api.zenobase.com" forHTTPHeaderField:@"Host"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *postData = [[NSString alloc] initWithFormat:@"grant_type=password&username=%@&password=%@",username,password];
    
    
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    //Prepare the data task
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //This block will be executed on the main thread once the data task has completed
        //Status Code is HTTP 200 OK
        //You have to cast to NSHTTPURLResponse, a subclass of NSURLResponse, to get the status code
        if ([(NSHTTPURLResponse*)response statusCode] == 200) {
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"%@", json);
            //The JSON is parsed into standard Cocoa classes such as NSArray, NSDictionary, NSString and NSNumber:
            NSLog(@"The requested access token was %@\n", json[@"access_token"]);
            self.ZBAccessTokenString = json[@"access_token"];
            self.ZBClientIDString = json[@"client_id"];
            [[NSUserDefaults standardUserDefaults] setObject:self.ZBAccessTokenString forKey:ZBACCESSTOKEN_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:self.ZBClientIDString forKey:ZBCLIENTID_KEY];
            [self.delegate didReceiveJSON:json];
            
        } else {
            NSLog(@"NSURLSession error response code = %ld",(long)[(NSHTTPURLResponse*)response statusCode]);
            
        }
    }];
    [dataTask resume];
    
}

-(void) addNewEventToBucket:(NSString *)bucketID withEvent:(NSDictionary *)eventDict // error: (NSError *) errorReturned
{

    
    
    NSString *parameterString = [[NSString alloc] initWithFormat:@"buckets/%@/",bucketID];
    
    NSString *urlString = [@"https://api.zenobase.com/" stringByAppendingString:parameterString];
    NSString *ZBBearer = [[NSString alloc] initWithFormat:@"Bearer %@",self.ZBAccessTokenString] ;
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:ZBBearer forHTTPHeaderField:@"Authorization"];
    [request setValue:@"api.zenobase.com" forHTTPHeaderField:@"Host"];
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:eventDict options:NSJSONWritingPrettyPrinted error:&error];
 
    NSAssert(!error,@"%@ in JSON Data", [error localizedDescription]);

    
    [request setHTTPBody:jsonData];
    NSURLSession *session = [NSURLSession sharedSession];
    //Prepare the data task
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSAssert(!error,@"error returning from add event to bucket");
        //This block will be executed on the main thread once the data task has completed
        //Status Code is HTTP 201 CREATED
        //You have to cast to NSHTTPURLResponse, a subclass of NSURLResponse, to get the status code
        if ([(NSHTTPURLResponse*)response statusCode] == 201) {
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", json);
            //The JSON is parsed into standard Cocoa classes such as NSArray, NSDictionary, NSString and NSNumber:
  
            
        } else {
            NSLog(@"NSURLSession error response code = %ld",(long)[(NSHTTPURLResponse*)response statusCode]);
            
        }
    }];
    [dataTask resume];
    
}


@end
