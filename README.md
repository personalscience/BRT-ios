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

*BTStimulusResponseView*: superclass for drawing your stimuli or responses in a view.  Subclass BTStartView draws a special start button. Subclass BTResponseView has a delegate that can handle responses (e.g. when touched).

    Subclass again with BTStimulusView if you want a stimulus that is not meant to be touched, or that will not be part of the response. For example, if you show something and expect the user to react quickly by pushing a different response key, show the stimulus as a BTStimulusView, not a BTResponseView (nor a BTStimulusResponseView)

*BTResponse*: contains all information related to the response a user made to a stimulus.


View Controllers
================

MoleView: viewer for the whack-a-mole UI
WedgeView: viewer for the wedge UI