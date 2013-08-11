WxMOO
=====

Perl/Wx MOO client.  Very very pre-alpha.

This is a response to Andrew Wilson's fantastic [tkMOO-light](http://www.awns.com/tkMOO-light) MOO client being basically abandoned, and tk-based, which is uugly, and coded in TCL which I find eye-stabbingly difficult to work with.  So I thought I'd see if I could reproduce the 75% of it that I use, in Perl which I understand, and Wx which looks like something even remotely from the 21st century, and so forth.

Done:
* It connects to a MOO.  My MOO at hayseed.net:7777, specifically.  That's hard-coded until I get a proper scheme for storing worlds.
* It takes input, and shows output.  Almost pleasantly, even.
* The input field has a super-basic but functional command history.
* It breaks horribly if you try many of the menu items.
* Oh, oh!  It filters ANSI codes out of the output.  Later it might even do something with them.

To do:
* Oh god, everything.
* Basic quality of life things like copy/paste, RMB menus, keyboard shortcuts.
* Saving prefs, fonts, colors, sizes, etc.  Themes are on the roadmap.  Gonna start with Solarized light and dark.
* ANSI support, 256-color most likely.
* MCP 2.1.  No, really, I'm gonna try.
* Proper list of 'worlds' / accounts, MOOs, what-have-you.  Pondering schemes to scrape online MOO lists to offer suggestions.
* local-edit with external editor.  Yay vim.
* object browser, like MacMOOSE but hopefully nicer.

Things that aren't currently on the rader:
* tkMOO-light has a whole plugin architecture, and all sorts of third-party additions (I even wrote one, years ago).  I'm not delusional enough to think that there'll be a flourishing ecosystem of developers around **this** MOO client.
* I MOO socially, occasionally.  I don't do RPG MUDs or things like that, so 

Guiding thoughts:
* Monospaced fonts and intuitive, pleasant uis are not inherently incompatible.
* There are a lot of wheels out there that have been invented well already.  My MOO client doesn't need its own text editor.  Lather, rinse, repeat.
* Nobody's living on a shell account on a VMS machine.  The MOO doesn't need to be a black-and-white culdesac.  There are dozens of interesting things a MOO client could do, connected to the 2013 Internet, that I haven't thought of yet.  Detect chat in a different language and offer to translate?  Tweet you when your friends log on?  Who knows.


(Aside, you could also check out my fork of tkMOO-light, [tkmoo-ttk](https://github.com/emersonrp/tkmoo-ttk), which moved lots of the innards of it to the ttk widget set, which was much more pleasant to look at.  I managed to break some stuff around the edges, though.  It's what I use day-to-day, until/unless this gets past the "toy" stage.)

