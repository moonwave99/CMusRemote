CMusRemote
==========

This is just a simple Cocoa GUI for brilliant terminal music player [cmus](http://cmus.sourceforge.net/).

The only thing I missed from it was the Apple Remote support, so I provided on my own.

It makes use of ```cmus-remote``` command to interact with the main program, so you can play/pause/seek/adjust volume as you wish.

The Remote bindings are:

*	Up button: turns volume up by 5%;
*	Up button (Hold): sets volume at max;
*	Down button: turns volume down by 5%;
*	Down button (Hold): mutes volume;
*	Right button: next song;
*	Left button: prev song;
*	Center button: toggles play/pause;
*	Menu button: toggles Status window.

Works in **10.6** / **10.7** as far as I tested.

If you have volume adjusting issues, you'll have to fix your ```~/.cmus/autosave``` settings somehow [I did months ago and I don't remember what I changed right now, sorry].

You can include the ```CMus.h``` / ```CMus.m``` files in your project if you need cmus bindings.

Well that's it, long live cmus!