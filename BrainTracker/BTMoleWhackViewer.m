//
//  BTMoleWhackViewer.m
//  BrainTracker
//
//  Created by Richard Sprague on 4/4/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
// Sets up the moles and the start button. Responds to events by passing them to the VC.


#import "BTMoleWhackViewer.h"
#import "BTResponse.h"
#import "BTStartView.h"

static const CGFloat kMoleHeight = 50;
//static const uint kMoleNumCols = 2;
//static const uint kMOleNumRows = 3;
//static const uint kMoleCount = kMOleNumRows * kMoleNumCols;


@interface BTMoleWhackViewer ()

@property (strong,nonatomic) BTStartView *startButton;
@property (strong, nonatomic) NSArray *moles;
@end

@implementation BTMoleWhackViewer

{
    NSTimeInterval prevTime;
    CGRect myFrame;
    CGFloat height;
    CGFloat width;
    NSMutableArray *tempMoles;// temp array to hold moles before copying to mutable
    
}

- (BTStartView *) makeStartButton: (CGRect) frame {
    
    BTResponse *response = [[BTResponse alloc] initWithString:[[[NSNumberFormatter alloc] init] stringFromNumber:@0]];
    BTStartView *button = self.startButton = [[BTStartView alloc] initWithFrame:frame forResponse:response];  // by convention, start button is always id=0
    self.startButton.delegate = self.motherViewer;
    [self addSubview:self.startButton];
    
    return button;
    
}

- (void) makeStartButton {
    
    if (!tempMoles) {
        tempMoles = [[NSMutableArray alloc] init];
    }
    
    CGFloat verticalCenter =width/2;
    
    BTStartView *button = [self makeStartButton:CGRectMake(kMoleHeight/2 + verticalCenter-kMoleHeight*3/2, height - kMoleHeight*2, kMoleHeight*3, kMoleHeight)];
    [button drawColor:[UIColor orangeColor]];
    
    [tempMoles addObject:button];
    
}

- (void) layOutViewsInArc {
    
   // [self makeStartButton];
    
    if (!tempMoles) {
        tempMoles = [[NSMutableArray alloc] init];
    }
    CGFloat verticalCenter =width/2;
    
    CGFloat kRuleHeight = height - height/2;
    CGFloat kLineLen = sqrtf(powf(verticalCenter,2)+powf(height - kRuleHeight,2));
    
    CGFloat theta = atanf((verticalCenter)/(height - kRuleHeight));
    
    CGFloat thetaPiece = 2*theta/5;
    int i = 0;
    uint index = 1;
    
    while (i<6) {
        CGFloat lenOpp = kLineLen * sinf(theta);  // lenght of the side opposite the theta angle
        CGFloat lenAdj = kLineLen * cosf(theta);
        CGFloat x = verticalCenter - lenOpp + kMoleHeight/2;
        CGFloat y = height - lenAdj;
        theta = theta - thetaPiece;
        
        BTResponse *response = [[BTResponse alloc]initWithString:[[[NSNumberFormatter alloc] init] stringFromNumber:[NSNumber numberWithInt:index++]]];
        
        BTResponseView *newMole = [[BTResponseView alloc]
                                   initWithFrame:CGRectMake(
                                                            x-kMoleHeight/2,
                                                            y-kMoleHeight/2,
                                                            kMoleHeight,
                                                            kMoleHeight)
                                   forResponse:response];
//        newMole.delegate = self;
        [self addSubview:newMole];
        
        i=i+1;
        [tempMoles addObject:newMole];
        
    }
    
    
    
    self.moles = [[NSArray alloc] initWithArray:tempMoles ];
    
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    myFrame = self.frame; // now I can calculate the size of the current view.
    height = myFrame.size.height;
    width = myFrame.size.width - kMoleHeight;
  //   self.backgroundColor = [UIColor clearColor];
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{  myFrame = self.frame; // now I can calculate the size of the current view.
    height = myFrame.size.height;
    width = myFrame.size.width - kMoleHeight;
   
    [self layOutViewsInArc];
}


@end
