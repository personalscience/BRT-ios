//
//  BTMoleLineViewer.swift
//  BrainTracker
//
//  Created by Richard Sprague on 5/6/15.
//  Copyright (c) 2015 Richard Sprague. All rights reserved.
//

import UIKit

let kMoleHeight:CGFloat = 50
var kMarginSpace:CGFloat = kMoleHeight / 6

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
            
        




    
    func makeMole(xy:CGPoint)
    {
        let response = BTResponse(string: NSNumberFormatter().stringFromNumber(3))
        let newMole = BTStimulusResponseView(frame: CGRectMake(xy.x,xy.y, kMoleHeight, kMoleHeight), forResponse: response)
        newMole.drawGreen()
        newMole.delegate = self.motherViewer
        
        self.addSubview(newMole)
    }
    
    // 
    // to make the following method behave like the BTMoleWhackViewer, just change its body to:
    //
    // super.layOutStimuli()
    
     public override func layOutStimuli()
    {
        
        var height = self.bounds.height
        var width = self.bounds.width
        var verticalCenter = width/2
        
    //    var row1Width = width/3
    //    var row2Width = width*2/3
        
        println("laying out \(kBTNumberOfStimuli) stimuli ")
        println("bounds = \(self.bounds)")
        
        /*
        let response = BTResponse(string: NSNumberFormatter().stringFromNumber(3))
        let newMole = BTStimulusResponseView(frame: CGRectMake(100, 100, 50, 75), forResponse: response)
        
        newMole.drawGreen()
        newMole.delegate = self.motherViewer
        
        self.addSubview(newMole)
    */
        
        self.makeMole(CGPointMake(verticalCenter - kMoleHeight/2, kMarginSpace + kMoleHeight))
        
        self.makeMole(CGPointMake(verticalCenter - kMoleHeight*2, kMarginSpace + kMoleHeight + kMarginSpace + kMoleHeight/2))
        self.makeMole(CGPointMake(verticalCenter + kMoleHeight*2, kMarginSpace + kMoleHeight + kMarginSpace + kMoleHeight/2))
       // super.layOutStimuli()
        
        
    }
    
    public override func drawRect(rect: CGRect) {
        println("drawRect in BTMoleLineViewer.swift")
        
        self.superview?.backgroundColor=UIColor.brownColor()
        
        
        
        var line1:UIBezierPath = UIBezierPath()
        var line2:UIBezierPath = UIBezierPath()

        
        line1.lineWidth = 1
        line2.lineWidth = 1
        
        line1.moveToPoint(CGPointMake(self.bounds.size.width/3,0))
        line2.moveToPoint(CGPointMake(self.bounds.size.width*2/3,0))
            
        line1.addLineToPoint(CGPointMake(self.bounds.size.width/3,self.bounds.size.height))
        line2.addLineToPoint(CGPointMake(self.bounds.size.width*2/3,self.bounds.size.height))
            
        UIColor.blueColor().setStroke()
            
        line1.stroke()
        line2.stroke()
        
       
        
        self.layOutStimuli()
    }

}
