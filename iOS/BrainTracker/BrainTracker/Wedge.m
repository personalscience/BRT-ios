//
//  Wedge.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/22/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "Wedge.h"

@implementation Wedge


// creates a wedge that fits in this view
/*
- (UIBezierPath *) wedge: (uint) wedgeNumber {
    
    
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    
    CGPoint origin  = self.bounds.origin;
    
    CGPoint center = CGPointMake(origin.x+width/2, origin.y+height/2);
    
    
    
    
    NSString *numLabelString = [[NSString alloc] initWithFormat:@"%d",wedgeNumber];
    NSAttributedString *numLabel = [[NSAttributedString alloc] initWithString:numLabelString];
    
    
    CGFloat startAngle = wedgeNumber * M_PI / 4.0;
    CGFloat endAngle= startAngle + M_PI / 4.0;
    
    
    // means left Edge Multiplier: a way to figure out which wedge you're in
    CGPoint leftEdgeX = [self edgeOffsetMultiplier:wedgeNumber];
    
    CGPoint leftEdge = CGPointMake(leftEdgeX.x*width,leftEdgeX.y * height);
    CGPoint rightEdgeX = [self edgeOffsetMultiplier:(wedgeNumber + 1) % 8]; // right edge is just one wedge ahead of the other 8 (hence the modulo)
    
    CGPoint rightEdge = CGPointMake(rightEdgeX.x*width,rightEdgeX.y * height);
    
    
    UIBezierPath *arc = [UIBezierPath bezierPath];
    
    [arc moveToPoint:leftEdge];
    [arc addArcWithCenter:CGPointMake(width/2, height/2) radius:[self responsePointRadius] startAngle:startAngle endAngle:endAngle clockwise:YES];
    [arc addLineToPoint:rightEdge]; //CGPointMake(width, 0.0)];
    //    [arc addLineToPoint: leftEdge]; //CGPointMake(width/2, 0.0)];
    
    [arc addLineToPoint:leftEdge];
    // [arc addLineToPoint:CGPointMake(width/2, height/2-[self responsePointRadius])];
    
    
    arc.lineWidth = 5.0;
    //  [[[self colorArray] objectAtIndex:wedgeNumber] setFill];
    //    [arc stroke];
    //    [arc fill];
    
    CGPoint numPlace = CGPointMake(center.x + (3 / 4 * (center.x - leftEdge.x)),center.y+(1/2 *(center.y-leftEdge.y)));
    
    //CGPointMake(leftEdge.x + (leftEdge.x-rightEdge.x)/2, leftEdge.y + (leftEdge.y-rightEdge.y)/2);
    CGRect wedgeBounds = arc.bounds;
    CGPoint wedgeCenterPoint = CGPointMake(wedgeBounds.origin.x + wedgeBounds.size.height /2, wedgeBounds.origin.y + wedgeBounds.size.width/2);
    
    CGPoint wedgeCentroid = CGPointMake((center.x+leftEdge.x+rightEdge.x)/3,(center.y+leftEdge.y+rightEdge.y)/3);
    
    [numLabel drawAtPoint:(CGPoint)wedgeCentroid];
    
    return arc;
    
    
    
}
*/

@end
