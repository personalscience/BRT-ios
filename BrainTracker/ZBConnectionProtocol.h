//
//  ZBConnectionProtocol.h
//  ZenobaseViewer
//
//  Created by Richard Sprague on 4/14/13.
//  Copyright (c) 2013 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>


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
