BrainTracker
============

Measure speed of reaction times, a la Seth Roberts

Instructions
============
Fairly obvious: press the start button, then hit the key that matches what you see.  Play again by either touching the same start button, or hit the "repeat" button.

Scores are kept on your iPhone, accessible from within iTunes and copyable to your desktop computer. Look for the file "BrainTrackerResultsFile.csv". Should be (mostly) self-explanatory.

Note that you can delete individual results (on the results page) by left-swiping the item on the table.

The Settings screen will let you populate the app with random values (10 at a time) if you want to test some of the other features (like the chart).


Architecture
============

**BTStimulusResponseView**: superclass for drawing your stimuli or responses in a view.  Subclass BTStartView draws a special start button. Subclass BTResponseView has a delegate that can handle responses (e.g. when touched).

Subclass again with BTStimulusView if you want a stimulus that is not meant to be touched, or that will not be part of the response. For example, if you show something and expect the user to react quickly by pushing a different response key, show the stimulus as a BTStimulusView, not a BTResponseView (nor a BTStimulusResponseView)

**BTResponse**: contains all information related to the response a user made to a stimulus.

**BTResultsTracker**: Instantiated once per user of the app, with contents saved in a CoreData database, and to disk. 


View Controllers
================

*  **BTHomeVC**: the main screen, for simple instructions and the initial start button.
*  **BTResultsVC**: display the trial and session results in a table

*  **BTSessionVC**: kicks off a series of trials based on Mole UI.
*  MoleView: viewer for the whack-a-mole UI
*  WedgeView: viewer for the wedge UI

*  BTStartVC: Wedges UI

*  BTSessionVC: an all-purpose VC for controlling a view of your session. Embed a view (e.g. BTMoleView or BTMoleWhackViewer or BTWedgeView) to display the type of trial you like.

Database
========
Results are stored in *BTDataStore* using CoreData. There are two entities:
* **BTDataTrial**: keeps the individual trial results
* **BTDataSession**: final results for a particular session, computed and saved once after each session.

Attributes:

Trial

    * _stimulus_ == problem (e.g. "showed ball number 6”)
    * _response_ == actual.answer (e.g. "tapped the wrong location”, “hit ball number 6”)
    * _latency_ == latency.msec (difference in time between when the stimulus was presented and when the response was received)
    * _timestamp_ == when  (the time at which the stimulus was presented)
    * _session_ == condition (unique identifier that applies to all trials in a particular session)
    * _foreperiod)_ (how long between warning the user and first presentation of the stimulus)
    * _whichSession_: one-to-one pointer to a session to which this trial belongs.

Session

    * whichTrial: one-to-many pointer to set of trials associated with this session
    * sessionRounds: number of rounds expected for this session
    * sessionID: (unique identifier that applies to all trials in this session)
    * SessionDate: a timestamp applied when the session is finished. 



Plotting uses the field "SessionScore" in BTDataSession for drawing the results of each session.



