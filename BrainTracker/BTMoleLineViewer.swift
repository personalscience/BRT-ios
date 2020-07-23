//
//  BTMoleLineViewer.swift
//  BrainTracker
//
//  Created by Richard Sprague on 5/6/15.
//  Copyright (c) 2015 Richard Sprague. All rights reserved.
//

import UIKit

var kMoleHeight:CGFloat = 85
var kMarginSpace:CGFloat = kMoleHeight / 4



@objc public class BTMoleLineViewer: BTMoleWhackViewer {
   

    var responseIndex:Int = 1 // which response is this
    var tempMoles = NSMutableArray()
    
    
    override init!(frame: CGRect, stimulus: BTStimulus!) {
        
        super.init(frame:frame, stimulus: stimulus)
        
        kMoleHeight = frame.height/5
        kMarginSpace = kMoleHeight/4
        
       
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    


    // create a new mole with response string = one more than the previous mole
    func makeMole(xy:CGPoint)
    {
        let newResponseIndex = responseIndex+1
        let response = BTResponse(string: NumberFormatter().string(from: NSNumber(value: newResponseIndex)))
        responseIndex+=1
        
        let newMole = BTResponseView(frame: CGRect(x: xy.x,y: xy.y, width: kMoleHeight, height: kMoleHeight), for: response)
        newMole?.drawGreen()
      //  newMole.alpha = 0.0
        newMole?.delegate = motherViewer
        
        tempMoles.add(newMole)
        
        self.addSubview(newMole!)
    }
    
       
     public override func layOutStimuli()
    {
        
  
        let fakeMole = BTStimulusResponseView(frame: CGRect(x: 0,y: 0, width: kMoleHeight, height: kMoleHeight),
                                              for: BTResponse(string:NumberFormatter().string(from: 1)))
        
        tempMoles.add(fakeMole)
        
 
        print("laying out \(kBTNumberOfStimuli) stimuli ")
        print("bounds = \(self.bounds)")
        
   //     println("Interface = \(BTInterfaceSelection.value)")
        
       
        
       if (BTInterfaceSelection == BTInterfaceArc)
       {
          super.layOutStimuli()
      } else
        
       {
        
    
    // don't display the top mole
      //  self.makeMole(CGPointMake(verticalCenter - kMoleHeight/2, kMarginSpace + kMoleHeight))
        
        var yHeight:CGFloat = 0
        var verticalCenter:CGFloat = self.bounds.width / 2
        
        for i in 1...3{
            var iFloat = CGFloat(i)
             yHeight =  (kMoleHeight)*(iFloat-1) + kMarginSpace * (iFloat)  + kMarginSpace
            
         
            self.makeMole(xy: CGPoint(x: self.bounds.size.width/4 - kMoleHeight/2, y: yHeight))
            self.makeMole(xy: CGPoint(x: self.bounds.size.width*3/4 - kMoleHeight/2, y: yHeight))
        }
       // super.layOutStimuli()
        
        
        moles = NSArray(array: tempMoles) as! [BTStimulusResponseView]

        
        print("moles count = \(super.moles.count)")
        }
        
    }
    
   
// inherits this from superclass, currently the same behavior.
//    public  override func presentForeperiod() {
//        
//        for (var i=1;
//            i < self.moles.count;
//            i++)
//        {
//            
//            self.moles[i].animatePresenceWithBlink()
//            
//        }
//    }
    
    func drawGrid() {
        var line1:UIBezierPath = UIBezierPath()
        var line2:UIBezierPath = UIBezierPath()
        var centerline:UIBezierPath = UIBezierPath()
        
        
        line1.lineWidth = 1
        line2.lineWidth = 1
        
        line1.move(to: CGPoint(x: self.bounds.size.width/4,y: 0))
        line2.move(to: CGPoint(x: self.bounds.size.width*3/4,y: 0))
        
        line1.addLine(to: CGPoint(x: self.bounds.size.width/4,y: self.bounds.size.height))
        line2.addLine(to: CGPoint(x: self.bounds.size.width*3/4,y: self.bounds.size.height))
        
        centerline.move(to: CGPoint(x: self.bounds.size.width/2, y: 0))
        centerline.addLine(to: CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height))
        
        UIColor.blue.setStroke()
        
        line1.stroke()
        line2.stroke()
        centerline.stroke()
        
    }
    
    public override func draw(_ rect: CGRect) {
        print("drawRect in BTMoleLineViewer.swift")
        
        drawGrid()
        
        self.superview?.backgroundColor = .brown
        
        
        
        
        
       
        
        self.layOutStimuli()
    }

}
