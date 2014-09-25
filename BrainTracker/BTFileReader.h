//
//  BTFileReader.h
//  BrainTracker
//
//  Created by Richard Sprague on 9/24/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const kBTMaxTrialsPerSessionKey;

@interface BTFileReader : NSObject

- (void) readFromDisk: (NSString *) dataFilePath;
@end
