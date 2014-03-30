//
//  BTStimulusView.m
//  PlayStimulusPresent
//
//  Created by Richard Sprague on 3/21/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTWedgeView.h"

#define RESPONSE_POINT_RADIUS 35.0



@implementation BTWedgeView

@synthesize wedges;

- (CGPoint) edgeOffsetMultiplierForWedgNumber: (uint) wedgeNumber withTotalWedges: (uint) numWedges width:(uint) width height: (uint) height {
    // given a wedgeNumber, returns the (width,height) multiplier for where a left wedge side should intercept the side of the rectangle.
    
   CGPoint offset = CGPointMake(width, height /2 );
    

    switch (wedgeNumber) {
        case 0:
            offset =CGPointMake(width, height/2);
            break;
        case 1:
            offset = CGPointMake(width, height);
            break;
        case 2:
            offset = CGPointMake(width/2,height);
            break;
        case 3:
            offset = CGPointMake(0,height);
            break;
        case 4:
            offset = CGPointMake(0,height/2);
            break;
        case 5:
            offset = CGPointMake(0,0);
            break;
        case 6:
            offset = CGPointMake(width/2,0);
            break;
        case 7:
            offset = CGPointMake(width,0);
            break;
        default:
            offset = CGPointMake(width, height/2);
            break;
    }
//
    
    float angleForWedge = wedgeNumber * (2* M_PI) / [BTWedgeView numWedges];  // angle (in radians) this wedge is pointing.
    
    float xPart = cosf(angleForWedge)*width/2 + width/2;
    float yPart =  sinf(angleForWedge)*height/2 + height/2;
    
//    float c= height/2;
//    
//    float a = sqrtf(pow(c*sinf(angleForWedge),2) + pow((height/2),2));
//    float x2 = width/2 +
    
    
/*  offset = CGPointMake(xPart
                        
                       // + cosf(angleForWedge-M_PI_2)*width/2
                        ,
                        
                        yPart
                        
                      //  + sinf(angleForWedge-M_PI_2)*width/2
                        )
    ;
*/
    
//    float y =width/2 / asinf(angleForWedge);
//    float x = height/2 / acos(angleForWedge);
    
    float y = asinf(angleForWedge)==0?width:(width/2)/asinf(angleForWedge);
    float x = acosf(angleForWedge) ==0?height:(height/2)/acosf(angleForWedge);
    
    
    
   // float y = asinf(angleForWedge)>width?width:asinf(angleForWedge);
    
    
    //  float x =height/2*tanf(angleForWedge)+width/2;
    
//    offset = CGPointMake(x,y);
//    NSLog(@"WedgeNumber=%d, offset=%@, angle=%f, (xPart=%f,yPart=%f), xy=(%f,%f)",wedgeNumber, NSStringFromCGPoint(CGPointMake(offset.x,offset.y)),angleForWedge, xPart,yPart,x,y);
    
    
    
    return offset;
    
    
}



- (CGFloat) responsePointRadius {
    
    return RESPONSE_POINT_RADIUS;
}

+ (uint) numWedges {
    return TOTAL_STIMULI ;
}

- (UIBezierPath *) circleAtCenterWithRadius: (CGFloat) radius {
    
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGPoint origin  = CGPointMake(width/2 - radius,height/2-radius);
    
    CGRect circleRect = CGRectMake(width/2 - radius, height/2 - radius, radius*2, radius*2 );
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    
    
    return path;
    
}


- (UIColor *) colorForWedge: (uint) n {
    
    NSArray *myColors = [self colorArray];
    UIColor *aColor = myColors[n % [[self colorArray] count]];
    
    return aColor;
    
}
- (NSArray *) colorArray {
    
    return @[[UIColor redColor], [UIColor purpleColor],[UIColor grayColor], [UIColor orangeColor], [UIColor magentaColor], [UIColor greenColor], [UIColor brownColor], [UIColor cyanColor]];
}

// creates a wedge that fits in this view

- (void) drawNumberInWedge: (uint) wedgeNumber{
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    
    CGPoint origin  = self.bounds.origin;
    
    CGPoint center = self.center; //CGPointMake(origin.x+width/2, origin.y+height/2);
    
    // means left Edge Multiplier: a way to figure out which wedge you're in
    CGPoint leftEdgeX = [self edgeOffsetMultiplierForWedgNumber:wedgeNumber withTotalWedges:[BTWedgeView numWedges] width:width height:height];
    
    CGPoint leftEdge = CGPointMake(leftEdgeX.x,leftEdgeX.y );
    CGPoint rightEdgeX = [self edgeOffsetMultiplierForWedgNumber:(wedgeNumber + 1) % [BTWedgeView numWedges] withTotalWedges:[BTWedgeView numWedges] width:width height:height]; // right edge is just one wedge ahead of the other 8 (hence the modulo)
    
    CGPoint rightEdge = CGPointMake(rightEdgeX.x,rightEdgeX.y );
    
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
    
    
    
    
    
    
    CGFloat startAngle = wedgeNumber * M_PI / ([BTWedgeView numWedges] / 2);
    CGFloat endAngle= startAngle + M_PI / ([BTWedgeView numWedges] / 2);
    
    
    // means left Edge Multiplier: a way to figure out which wedge you're in
    CGPoint leftEdgeX = [self edgeOffsetMultiplierForWedgNumber:wedgeNumber withTotalWedges:[BTWedgeView numWedges] width:width height:height];
    
    CGPoint leftEdge = CGPointMake(leftEdgeX.x,leftEdgeX.y );
    
    CGPoint rightEdgeX = [self edgeOffsetMultiplierForWedgNumber:(wedgeNumber + 1) % [BTWedgeView numWedges] withTotalWedges:[BTWedgeView numWedges] width:width height:height]; // right edge is just one wedge ahead of the other 8 (hence the modulo)
    
    CGPoint rightEdge = CGPointMake(rightEdgeX.x,rightEdgeX.y );
    
    
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
            
            for (int w =0;w<[BTWedgeView numWedges];w++){
                UIBezierPath *wedge = [self wedge: w];
                [tempWedges addObject:wedge];
                
                [[self colorForWedge:w] setFill];
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
