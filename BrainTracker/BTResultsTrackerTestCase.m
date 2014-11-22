//
//  BTResultsTrackerTestCase.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/30/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTResultsTracker.h"

@interface BTResultsTrackerTestCase : XCTestCase

@end

@implementation BTResultsTrackerTestCase

- (void) testPercentileOfResponseIsCorrectWithThreeItems {
        NSLog(@"%s doing work...", __PRETTY_FUNCTION__);
  //XCTAssertEqualWithAccuracy(percent, 0, 1.0, @"Percentile is way off");
    
}

- (void)setUp
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [super tearDown];
}

/*
- (void)testExample
{  NSLog(@"%s doing work...", __PRETTY_FUNCTION__);
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}
 */

@end
