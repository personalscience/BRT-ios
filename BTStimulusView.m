//
//  BTStimulusView.m
//  PlayStimulusPresent
//
//  Created by Richard Sprague on 3/21/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTStimulusView.h"

#define RESPONSE_POINT_RADIUS 35.0


@implementation BTStimulusView

@synthesize wedges;

- (CGPoint) edgeOffsetMultiplier: (uint) wedgeNumber {
    // given a wedgeNumber, returns the (width,height) multiplier for where a left wedge side should intercept the side of the rectangle.
    
    CGPoint offset = CGPointMake(1, 0.5);
    
    switch (wedgeNumber) {
        case 0:
            offset =CGPointMake(1, 0.5);
            break;
        case 1:
            offset = CGPointMake(1, 1);
            break;
        case 2:
            offset = CGPointMake(0.5,1);
            break;
        case 3:
            offset = CGPointMake(0,1.0);
            break;
        case 4:
            offset = CGPointMake(0,0.5);
            break;
        case 5:
            offset = CGPointMake(0,0);
            break;
        case 6:
            offset = CGPointMake(0.5,0);
            break;
        case 7:
            offset = CGPointMake(1,0);
            break;
        default:
            offset = CGPointMake(1, 0.5);
            break;
    }
    
    return offset;
    
    
}


- (CGFloat) responsePointRadius {
    
    return RESPONSE_POINT_RADIUS;
}

- (UIBezierPath *) circleAtCenterWithRadius: (CGFloat) radius {
    
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGPoint origin  = CGPointMake(width/2 - radius,height/2-radius);
    
    CGRect circleRect = CGRectMake(width/2 - radius, height/2 - radius, radius*2, radius*2 );
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    
    
    return path;
    
}


- (NSArray *) colorArray {
    
    return @[[UIColor redColor], [UIColor purpleColor],[UIColor grayColor], [UIColor orangeColor], [UIColor magentaColor], [UIColor greenColor], [UIColor brownColor], [UIColor cyanColor]];
}

// creates a wedge that fits in this view

- (void) drawNumberInWedge: (uint) wedgeNumber{
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    
    CGPoint origin  = self.bounds.origin;
    
    CGPoint center = CGPointMake(origin.x+width/2, origin.y+height/2);
    
    // means left Edge Multiplier: a way to figure out which wedge you're in
    CGPoint leftEdgeX = [self edgeOffsetMultiplier:wedgeNumber];
    
    CGPoint leftEdge = CGPointMake(leftEdgeX.x*width,leftEdgeX.y * height);
    CGPoint rightEdgeX = [self edgeOffsetMultiplier:(wedgeNumber + 1) % 8]; // right edge is just one wedge ahead of the other 8 (hence the modulo)
    
    CGPoint rightEdge = CGPointMake(rightEdgeX.x*width,rightEdgeX.y * height);
    
    CGPoint wedgeCentroid = CGPointMake((center.x+leftEdge.x+rightEdge.x)/3,(center.y+leftEdge.y+rightEdge.y)/3);
    
    NSString *numLabelString = [[NSString alloc] initWithFormat:@"%d",wedgeNumber];
    NSAttributedString *numLabel = [[NSAttributedString alloc] initWithString:numLabelString];
    
    [numLabel drawAtPoint:(CGPoint)wedgeCentroid];
    
    
}
- (UIBezierPath *) wedge: (uint) wedgeNumber {
    
    
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    
    CGPoint origin  = self.bounds.origin;
    
    CGPoint center = CGPointMake(origin.x+width/2, origin.y+height/2);
    
    
    
    
    
    
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
    
//    CGPoint numPlace = CGPointMake(center.x + (3 / 4 * (center.x - leftEdge.x)),center.y+(1/2 *(center.y-leftEdge.y)));
//    
//    //CGPointMake(leftEdge.x + (leftEdge.x-rightEdge.x)/2, leftEdge.y + (leftEdge.y-rightEdge.y)/2);
//    CGRect wedgeBounds = arc.bounds;
//    CGPoint wedgeCenterPoint = CGPointMake(wedgeBounds.origin.x + wedgeBounds.size.height /2, wedgeBounds.origin.y + wedgeBounds.size.width/2);
//    
//    CGPoint wedgeCentroid = CGPointMake((center.x+leftEdge.x+rightEdge.x)/3,(center.y+leftEdge.y+rightEdge.y)/3);
//    
//    NSString *numLabelString = [[NSString alloc] initWithFormat:@"%d",wedgeNumber];
//    NSAttributedString *numLabel = [[NSAttributedString alloc] initWithString:numLabelString];
//    
//    [numLabel drawAtPoint:(CGPoint)wedgeCentroid];
    
    return arc;
    
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}




- (void)drawRect:(CGRect)rect
{
 [[UIColor blackColor] setStroke];
 [[UIColor blueColor] setFill];
 
    if (wedges) { // a wedge array already exists, so just draw what's in there.
        for (UIBezierPath *wedge in wedges) {
            [wedge stroke];
            
        }}
        else // presumably this is the first time this view is called, so create all the wedges from scratch
        {
            
            NSMutableArray *tempWedges = [[NSMutableArray alloc] init];
            
            for (int w =0;w<8;w++){
                UIBezierPath *wedge = [self wedge: w];
                [tempWedges addObject:wedge];
                
                [[[self colorArray] objectAtIndex:w] setFill];
                [wedge stroke];
                [wedge fill];
                [self drawNumberInWedge:w];
            }
            // final "wedge" is actually a circle, at the center of the view.
            UIBezierPath *cPath = [self circleAtCenterWithRadius:RESPONSE_POINT_RADIUS];
            [[UIColor whiteColor] setFill];
            [cPath fill];
            [tempWedges addObject:cPath];
            
            self.wedges = [[NSArray alloc] initWithArray:tempWedges copyItems:YES];
        }
 

        
 
 [[UIColor redColor] setFill];
 
}


@end
