//
//  BTMoleLineViewer.swift
//  BrainTracker
//
//  Created by Richard Sprague on 5/6/15.
//  Copyright (c) 2015 Richard Sprague. All rights reserved.
//

import UIKit


@objc public class BTMoleLineViewer: BTMoleWhackViewer {
    
    
    let mole = NSMutableArray()
    
    // 
    // to make the following method behave like the BTMoleWhackViewer, just change its body to:
    //
    // super.layOutStimuli()
    
     public override func layOutStimuli()
    {
        println("laying out \(kBTNumberOfStimuli) stimuli ")
        println("bounds = \(self.bounds)")
        
        /*
        let response = BTResponse(string: NSNumberFormatter().stringFromNumber(3))
        let newMole = BTStimulusResponseView(frame: CGRectMake(100, 100, 50, 75), forResponse: response)
        
        newMole.drawGreen()
        newMole.delegate = self.motherViewer
        
        self.addSubview(newMole)
    */
        super.layOutStimuli()
        
        
    }

}
