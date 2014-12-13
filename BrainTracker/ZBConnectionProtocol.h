//
//  ZBConnectionProtocol.h
//  ZenobaseViewer
//
//  Created by Richard Sprague on 4/14/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ZBUSERNAME_KEY @"USERNAME"
#define ZBPASSWORD_KEY @"PASSWORD"
#define ZBACCESSTOKEN_KEY @"ACCESSTOKEN"
#define ZBCLIENTID_KEY @"CLIENTID"
#define ZBSCOPETOKEN_KEY @"ZBSCOPETOKEN"

typedef NS_ENUM(NSInteger, ZBReturnType) {
    ZBBuckets,                  // buckets
    ZBEvents                 // events
};

@protocol ZBConnectionProtocol <NSObject>

// You set up a connection.  If you implemenet this protocol, you'll get back some JSON from that connection.  That's all you know.
- (void)didReceiveJSON: (NSDictionary *)json;

@optional
- (id) ZBUserID;


@end
