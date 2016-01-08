WxMOO
=====

Perl/Wx MOO client, very work-in-progress.  It's intended to run on Windows, MacOS, and Linux/etc.  Currently it can't be properly said to run on any of them.

This is a response to Andrew Wilson's fantastic [tkMOO-light](http://www.awns.com/tkMOO-light) MOO client being basically abandoned, and tk-based, which is uugly, and coded in TCL which I find eye-stabbingly difficult to work with.  So I thought I'd see if I could reproduce the 75% of it that I use, in Perl which I understand, and Wx which looks like something even remotely from the 21st century, and so forth.

Done:
* It connects to a MOO.  Initially, hard-coded to my MOO at hayseed.net:7777, specifically, but the Worlds->Connect dialog now works to connect wherever you like.
* It takes input, and shows output.  Almost pleasantly, even.
* The input field has a super-basic but functional command history.
* ANSI color/style codes are, for the most part, honored.
* Incomplete [MCP/2.1](http://www.moo.mud.org/mcp/mcp2.html) implementation -- mcp-notify is implemented, but mcp-cord is not.
* Starting in on MCP packages: dns-org-mud-moo-simpleedit done, external editor configurable
* ~~Saving prefs now works, for the small set of prefs it honors.~~ (This is currently not working fantastically well.)

0.1 Milestone:
* fix output pane scroll-to-bottom behavior to dwym
* Finish keyboard accelerators;  page-up/down etc


To do:
* Add proper prefs and world/connection handling (75% done!)
* Start making sure it works on Windows and MacOS.  Currently, almost surely it doesn't.
* Start rolling binary packages for all platforms once it's remotely useful to anyone but me.
* Basic quality of life things like keyboard shortcuts. (50% done!)
* Customizable colors / themes
* Per-world settings?  Colors, fonts?j
* Complete the MCP 2.1 implementation.  It does the version dance with the server (both the MCP version, and mcp-negotiate package-version), but ignores whatever it sees.  Also mcp-cord isn't implemented at all.
* Proper list of 'worlds' / accounts, MOOs, what-have-you.  Pondering schemes to scrape online MOO lists to offer suggestions.
* object browser, like MacMOOSE but hopefully nicer.
* inline MOO syntax highlighting?  Like, detect the output of "@list $player:tell" and auto-highlight it?
* Connections will hopefully have a 'connection type' -- currently thinking in terms of plain'ol TCP port, SSL, and SSH port forwarding (automagic at connection time).

Blue-sky:
* HTML help, using jtext?
* MIME-based external apps, ie mplayer for audio/flac etc?  MCP package to accept MIME+data?

Things that aren't currently on the rader:
* tkMOO-light has a whole plugin architecture, and all sorts of third-party additions (I even wrote one, years ago).  I'm not delusional enough to think that there'll be a flourishing ecosystem of developers around **this** MOO client, so I'm not actually desigining with that in mind.
* I MOO socially, occasionally.  I don't do RPG MUDs or things like that, so I have no need for triggers and macros and so forth.  I don't even have a clear idea of what people do with them.

Guiding thoughts:
* Monospaced fonts and line-based terminal output are not mutually incompatible with intuitive, pleasant uis.
* There are many wheels out there that have been invented well already.  My MOO client doesn't need its own built-in text editor.  Lather, rinse, repeat.
* Nobody's living on a shell account on a VMS machine.  The MOO doesn't need to be a black-and-white culdesac.  There are dozens of interesting things a MOO client could do, connected to the 21st-century Internet, that I haven't thought of yet.  Detect chat in a different language and offer to translate?  Tweet you when your friends log on?  Display Google Maps for a MOO that knows how to host that?  Who knows.


(Aside, you could also check out my fork of tkMOO-light, [tkmoo-ttk](https://github.com/emersonrp/tkmoo-ttk), which moved lots of the innards of it to the ttk widget set, which was much more pleasant to look at.  I managed to break some stuff around the edges, though.  It's what I use day-to-day, until/unless this gets past the "toy" stage.)

Dependencies
------------

WxMOO requires perl 5.14 or newer, and WxWidgets 3.  Getting a working wxWidgets 3 + wxPerl on Fedora is a little cranky-making but it fixes some quirks that I'd otherwise have to fix in hinky hackish perl customizations.  My sincere hope is that Fedora will start shipping wxPerl compiled against wx3 and our long national nightmare will be over.

(You -can- run it with wx2.8, but there might be input weirdness of various types.)

As far as further perl dependencies, Module::ScanDeps (not itself a dependency) reports the following:

    Carp
    Carp::Heavy
    Class::Accessor
    constant
    Cwd
    Data::Dumper
    Encode
    Encode::Alias
    Encode::Config
    Encode::Encoding
    Encode::MIME::Name
    Exporter
    Exporter::Heavy
    File::Path
    File::Slurp
    File::Spec
    File::Spec::Unix
    File::Temp
    JSON
    JSON::PP
    JSON::PP::Boolean
    List::Util
    parent
    Scalar::Util
    Socket
    Storable
    Sub::Util
    threads
    Wx
    Wx::App
    Wx::Event
    Wx::Loader::Custom
    Wx::Locale
    Wx::Menu
    Wx::Mini
    Wx::Print
    Wx::RadioBox
    Wx::RichText
    Wx::Socket
    Wx::Timer
    Wx::Wx_Exp

Acknowledgements
----------------

* wxmoo is inspired by (and occasionally directly borrows from) [Andrew Wilson](http://www.awns.com)'s [tkMOO-light](http://www.awns.com/tkMOO-light), which is still probably the most-capable and -advanced MOO client around.
* [PADRE](http://padre.perlide.org) is not something I use, being a [vim](http://www.vim.org) junkie, but their generously-licensed code for a production wxperl application has been an invaluable reference.
* [Daring Fireball](http://www.daringfireball.net)'s blog graciously supplied to the public domain the [URL-detecting regex](http://daringfireball.net/2010/07/improved_regex_for_matching_urls) that I adapted.



