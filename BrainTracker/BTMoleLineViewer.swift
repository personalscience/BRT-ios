//
//  BTMoleLineViewer.swift
//  BrainTracker
//
//  Created by Richard Sprague on 5/6/15.
//  Copyright (c) 2015 Richard Sprague. All rights reserved.
//

import UIKit


@objc public class BTMoleLineViewer: BTMoleWhackViewer {
    
    // layOutStimuli
    
     public override func layOutStimuli()
    {
        println("laying out stimuli")
        super.layOutStimuli()
        
        
        // Steps needed:
        // instantiate a number of BTResponseView objects ("moles") 
        //    each of which includes a BTResponse
        // add the new mole to the subview of this class
    }

}
