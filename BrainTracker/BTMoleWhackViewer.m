//
//  BTMoleWhackViewer.m
//  BrainTracker
//
//  Created by Richard Sprague on 4/4/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//
// Sets up the moles and the start button. Responds to events by passing them to the VC.
// There is only one stimulus for this viewer and it will display it

// 


#import "BTMoleWhackViewer.h"
#import "BTResponse.h"
#import "BTStimulus.h"
#import "BTStartView.h"

extern uint const kBTNumberOfStimuli;

static const CGFloat kMoleHeight = 50;  // size for the mole object you will try to whack
//static const uint kMoleNumCols = 2;
//static const uint kMOleNumRows = 3;
//static const uint kMoleCount = kMOleNumRows * kMoleNumCols;


@interface BTMoleWhackViewer ()

@property (strong,nonatomic) BTStartView *startButton;
@property (strong, nonatomic) NSArray *moles;  // each mole is a potential stimulus. this array contains all possible stimulii
@property (strong, nonatomic) BTStimulus *stimulus; //this viewer has a single stimulus associated with it.
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
    
    CGFloat verticalCenter = width/2;
    
    // make an oval-shaped object for the start button
    
    BTStartView *button = [self makeStartButton:CGRectMake(kMoleHeight/2 + verticalCenter-kMoleHeight*3/2, height - kMoleHeight*2, kMoleHeight*3, kMoleHeight)];
    [button drawColor:[UIColor orangeColor]];
    button.alpha = 1.0;
    
    UILabel *newLabel = [[UILabel alloc] init];
    newLabel.attributedText =[[NSMutableAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"Press and Hold"]];
    button.label = newLabel;
 
    
    [tempMoles addObject:button];
    
}

- (void) changeStartButtonLabelTo: (NSString *) newLabel{
    
    if(!self.moles){
        NSAssert(!self.moles,@"Trying to change mole button label but there are no moles");
        
    } else {
        UILabel *aLabel = [[UILabel alloc] init];
        aLabel.attributedText =[[NSMutableAttributedString alloc] initWithString:[[NSString alloc] initWithString:newLabel]];
        [self.moles[0] setLabel:aLabel];
        [self.moles[0] setNeedsDisplay];
    }
    
}


- (void) presentNewStimulusResponse {
    
    // the stimulus is the randomMole index in the self.moles array ]
    int randomMole = [self.stimulus valueAsInt]; //(arc4random() % ([self.moles count]-1))+1 ; // ignore the first mole (which is really just the start button)
    
   // int randomMoleFromStimulus = [self.stimulus valueAsInt];
  /*  for (uint i=1;i<[self.moles count]; i++){
        [self.moles[i] setAlpha:0.0];
    }
   */
   // [self clearAllResponsesExcept:randomMole];
    [self clearAllResponses];
    

    BTResponseView *responseView = self.moles[randomMole]; //[self.moles objectAtIndex:randomMole];
    [responseView drawRed];
    //[self.moles[randomMole] drawRed];
    responseView.alpha = 1.0;

    [self changeStartButtonLabelTo:@""];
    [responseView setNeedsDisplay];
    
    
    
}

- (void) clearAllResponses {
    
    for (uint i=1;i<[self.moles count]; i++){
        [self.moles[i] setAlpha:0.0];
        [self.moles[i] drawGreen];
       // [self.moles[i] animatePresenceWithBlink];
    }
    

}

- (void) presentForeperiod {
    for (uint i=1;i<[self.moles count]; i++){
        [self.moles[i] animatePresenceWithBlink];
    }
    
    
}

//- (void) clearAllResponsesExcept: (uint) targetNumber {
//    
//    for (uint i=1;i<[self.moles count]; i++){
//        //[self.moles[i] setAlpha:0.0];
//        if (i!=targetNumber){[self.moles[i] animatePresenceWithBlink];}
//        else [self.moles[i] animatePresenceAndStay];
//            
//        
//        
//    }
//    
//    
//}

// used to be layOutViewsInArc
- (void) layOutStimuli {
    
   // [self makeStartButton];
    
    if (!tempMoles) {
        tempMoles = [[NSMutableArray alloc] init];
    }
    
    CGFloat verticalCenter =width/2;
    
    CGFloat kRuleHeight = height  * 1/3 ;  // vertical position in the view where the moles will appear
    CGFloat kLineLen = sqrtf(powf(verticalCenter,2)+powf(height - kRuleHeight,2)); // length of the line from the start button to the mole.  [this isn't a constant.  the name begins with 'k' to remind me that it's constant on this particular calculation.
    
    CGFloat theta = atanf((verticalCenter)/(height - kRuleHeight));
    
    CGFloat thetaPiece = 2*theta/5;
    int i = 0;
    uint index = 1;
    
    while (i<kBTNumberOfStimuli) {
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
        [newMole drawGreen];
        newMole.alpha=0.0;
        
        newMole.delegate = self.motherViewer;
        [self addSubview:newMole];
        
        i=i+1;
        [tempMoles addObject:newMole];
    }
        self.moles = [[NSArray alloc] initWithArray:tempMoles ];
   
       
    
    
}



- (id)initWithFrame:(CGRect)frame stimulus: (BTStimulus *) stimulus
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    myFrame = self.frame; // now I can calculate the size of the current view.
    height = myFrame.size.height;
    width = myFrame.size.width - kMoleHeight;
    self.stimulus = stimulus;
  //   self.backgroundColor = [UIColor clearColor];
    return self;
}



- (void)drawRect:(CGRect)rect
{  myFrame = self.frame; // now I can calculate the size of the current view.
    height = myFrame.size.height;
    width = myFrame.size.width - kMoleHeight;
   
    [self layOutStimuli];
}


@end
