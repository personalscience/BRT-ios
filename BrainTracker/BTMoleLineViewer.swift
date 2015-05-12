//
//  BTMoleLineViewer.swift
//  BrainTracker
//
//  Created by Richard Sprague on 5/6/15.
//  Copyright (c) 2015 Richard Sprague. All rights reserved.
//

import UIKit

let kMoleHeight:CGFloat = 50
var kMarginSpace:CGFloat = kMoleHeight / 4

/*

The view is divided into these 5 sections

top: a single mole, centered

middle rows
row 1
row 2
row 3

bottom: always contains the start button, nothing more

each section should be of height marginSpace + kMoleHeight + marginSpace
marginSpace = kMoleHeight / 6


*/


@objc public class BTMoleLineViewer: BTMoleWhackViewer {
    
    var height:CGFloat = 0.0
    var width:CGFloat = 0.0
    var verticalCenter:CGFloat = 0.0
    var responseIndex:Int = 1 // which response is this
    var tempMoles = NSMutableArray()
    

   
    override init!(frame: CGRect, stimulus: BTStimulus!) {
        
        super.init(frame:frame, stimulus: stimulus)
        
        var height = self.bounds.height
        var width = self.bounds.width
        var verticalCenter = width/2
        
        
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     /*
        
            var height = self.bounds.height
            var width = self.bounds.width
            var verticalCenter = width/2
*/
            
        

  //  BTResponse *response = [[BTResponse alloc]initWithString:[[[NSNumberFormatter alloc] init] stringFromNumber:[NSNumber numberWithInt:index++]]];
    


    // create a new mole with response string = one more than the previous mole
    func makeMole(xy:CGPoint)
    {
        let response = BTResponse(string: NSNumberFormatter().stringFromNumber(responseIndex++))
        let newMole = BTStimulusResponseView(frame: CGRectMake(xy.x,xy.y, kMoleHeight, kMoleHeight), forResponse: response)
        newMole.drawGreen()
        newMole.delegate = self.motherViewer
        
        tempMoles.addObject(newMole)
        
        self.addSubview(newMole)
    }
    
       
     public override func layOutStimuli()
    {
        
        var height = self.bounds.height
        var width = self.bounds.width
        var verticalCenter = width/2
        
        let fakeMole = BTStimulusResponseView(frame: CGRectMake(0,0, kMoleHeight, kMoleHeight), forResponse: BTResponse(string:NSNumberFormatter().stringFromNumber(1)))
        
        tempMoles.addObject(fakeMole)
        
        
    //    var row1Width = width/3
    //    var row2Width = width*2/3
        
        println("laying out \(kBTNumberOfStimuli) stimuli ")
        println("bounds = \(self.bounds)")
        
   //     println("Interface = \(BTInterfaceSelection.value)")
        
       
        
       if (BTInterfaceSelection.value == BTInterfaceArc.value)
       {
          super.layOutStimuli()
      } else
        
       {
        
    
    // don't display the top mole
      //  self.makeMole(CGPointMake(verticalCenter - kMoleHeight/2, kMarginSpace + kMoleHeight))
        
        var yHeight:CGFloat = 0
        
        for i in 1...3{
            var iFloat = CGFloat(i)
             yHeight =  kMarginSpace * CGFloat(3) + kMarginSpace * iFloat + kMoleHeight*iFloat + kMarginSpace * iFloat  + kMoleHeight/2
            
            self.makeMole(CGPointMake(verticalCenter - kMoleHeight*2, yHeight))
            self.makeMole(CGPointMake(verticalCenter + kMoleHeight, yHeight))
        }
       // super.layOutStimuli()
        
        
        self.moles = NSArray(array: tempMoles) as! [BTStimulusResponseView]

        
        println("moles count = \(super.moles.count)")
        }
        
    }
        

    
    public override func drawRect(rect: CGRect) {
        println("drawRect in BTMoleLineViewer.swift")
        
        self.superview?.backgroundColor=UIColor.brownColor()
        
        
        
        var line1:UIBezierPath = UIBezierPath()
        var line2:UIBezierPath = UIBezierPath()
        var centerline:UIBezierPath = UIBezierPath()

        
        line1.lineWidth = 1
        line2.lineWidth = 1
        
        line1.moveToPoint(CGPointMake(self.bounds.size.width/3,0))
        line2.moveToPoint(CGPointMake(self.bounds.size.width*2/3,0))
            
        line1.addLineToPoint(CGPointMake(self.bounds.size.width/3,self.bounds.size.height))
        line2.addLineToPoint(CGPointMake(self.bounds.size.width*2/3,self.bounds.size.height))
        
        centerline.moveToPoint(CGPointMake(self.bounds.size.width/2, 0))
        centerline.addLineToPoint(CGPointMake(self.bounds.size.width/2, self.bounds.size.height))
            
        UIColor.blueColor().setStroke()
            
        line1.stroke()
        line2.stroke()
        centerline.stroke()
        
       
        
        self.layOutStimuli()
    }

}
