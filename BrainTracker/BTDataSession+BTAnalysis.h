//
//  BTDataSession+BTAnalysis.h
//  BrainTracker
//
//  Created by Richard Sprague on 9/23/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTDataSession.h"

@interface BTDataSession (BTAnalysis)

// recalculate every sessionScore in entity BTDataSession, using all trial information, including those that may have happened AFTER you originally ran this session

+ (void) updateSessionScores: (NSManagedObjectContext *) context ;


@end
