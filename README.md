BrainTracker
============

An algorithm developed by the late [Seth Roberts](https://sethroberts.net/), Professor of Psychology at University of California, Berkeley is based on his research showing that the speed at which you react to stimulii is a proxy measurement of your overall mental acuity. Dr. Roberts tested his algorithm for decades on himself, having implemented a version in the R programming language, and used the results to uncover many interesting and actionable self-improvement techniques, which he described using the term "Personal Science", the discipline of using science for personal  rather than professional reasons.

The initial version of this app was developed in collaboration with Dr. Roberts in early 2014, though his untimely passing prevented its release for many years. Rewritten from his [publicly available code](https://github.com/personalscience/braintracker), it contains a number of significant improvements to make it more accessible to the general public, though it is far from complete. Lacking final tweaks and feedback from Dr. Roberts, it is released here "as-is", in the hopes that it may be of some benefit, or perhaps serve as inspiration for a motivated team to upgrade it to its full potential.

Instructions
============

Enter your initial conditions as text on the first screen and press "start" to switch to the testing screen. Press and hold the button at the bottom and wait until a red ball appears. Release the button and try to hit the ball as quickly as you can. Repeat this for as many times as the test requires.  The default number of times per session is 32, though you may change that in the settings screen.

Scores are kept on your iPhone and are visible in the "Results" tab.  You can also copy a CSV version of all your results directly from your computer if you attach your iPhone and look under Files" for  "BrainTrackerResultsFile.csv". Should be (mostly) self-explanatory.

Note that you can delete individual results (on the results page) by left-swiping the item on the table.

The Settings screen will let you populate the app with random values (10 at a time) if you want to test some of the other features.


Architecture
============

**BTStimulusResponseView**: superclass for drawing your stimuli or responses in a view.  Subclass BTStartView draws a special start button. Subclass BTResponseView has a delegate that can handle responses (e.g. when touched).

Subclass again with BTStimulusView if you want a stimulus that is not meant to be touched, or that will not be part of the response. For example, if you show something and expect the user to react quickly by pushing a different response key, show the stimulus as a BTStimulusView, not a BTResponseView (nor a BTStimulusResponseView)

**BTResponse**: contains all information related to the response a user made to a stimulus.

**BTResultsTracker**: Instantiated once per user of the app, with contents saved in a CoreData database, and to disk. 

Protocols
=========
**BTTouchReturnedProtocol**: __didReceiveResponse__ will send back which string was pressed and the latency.

View Controllers
================

*  **BTHomeVC**: the main screen, for simple instructions and the initial start button.
*  **BTResultsVC**: display the trial and session results in a table

*  **BTSessionVC**: kicks off a series of trials based on Mole UI.

*  **BTStartVC**: Wedges UI

*  **BTSessionVC**: an all-purpose VC for controlling a view of your session. Embed a view (e.g. BTMoleView or BTMoleWhackViewer or BTWedgeView) to display the type of trial you like.

Viewers
=======

A view knows absolutely nothing about a session. It just  kicks off some instances of BTStimulusResponseView nicely laid out. Those instances return a **BTResponse** when touched.

*  **MoleWhackViewer**: viewer for the whack-a-mole UI
*  **BTMoleLineViewer**: a subclass of BTMoleWhackViewer (written in Swift)
*  **WedgeView**: viewer for the wedge UI

Database
========
Results are stored in *BTDataStore* using CoreData. There are two entities:
* **BTDataTrial**: keeps the individual trial results
* **BTDataSession**: final results for a particular session, computed and saved once after each session.

Attributes:

Trial

* __stimulus__ == problem (e.g. "showed ball number 6”)
* __response__ == actual.answer (e.g. "tapped the wrong location”, “hit ball number 6”)
* __latency__ == latency.msec (difference in time between when the stimulus was presented and when the response was received)
* __timestamp__ == when  (the time at which the stimulus was presented)
* __session__ == condition (unique identifier that applies to all trials in a particular session)
* __foreperiod__ (how long between warning the user and first presentation of the stimulus)
* __whichSession__: one-to-one pointer to a session to which this trial belongs.

Session

* whichTrial: one-to-many pointer to set of trials associated with this session
* sessionRounds: number of rounds expected for this session
* sessionID: (unique identifier that applies to all trials in this session)
* SessionDate: a timestamp applied when the session is finished. 


Plotting uses the field "SessionScore" in BTDataSession for drawing the results of each session.

Debugging
=========
* "Update Scores" on the Results tab will 
* "Fill database with sample" on the _Settings_ tab will load the database with whatever's in the BrainTrackerResultsFile.CSV


Zenobase
========
Session results are saved to a store at http://zenobase.com. You must enter your credentials first in the setup page.

Change Log
==========

2020-07-23: Updated for iOS 13.

2015-09-8: BTResultsTracker includes - (NSArray) trialsMatchingResponse  and only looks at the latest  kBTlastNTrialsCutoffValue (sorted chronologically) trials 

2015-05-06: Swift language bridging headers added.


