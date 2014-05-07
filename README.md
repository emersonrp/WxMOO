WxMOO
=====

Perl/Wx MOO client.  Very pre-alpha.  It's intended to run on Windows, MacOS, and Linux/etc.  Currently it can't be properly said to run on any of them.

This is a response to Andrew Wilson's fantastic [tkMOO-light](http://www.awns.com/tkMOO-light) MOO client being basically abandoned, and tk-based, which is uugly, and coded in TCL which I find eye-stabbingly difficult to work with.  So I thought I'd see if I could reproduce the 75% of it that I use, in Perl which I understand, and Wx which looks like something even remotely from the 21st century, and so forth.

Done:
* It connects to a MOO.  Initially, hard-coded to my MOO at hayseed.net:7777, specifically, but the Worlds->Connect dialog now works to connect wherever you like.
* It takes input, and shows output.  Almost pleasantly, even.
* The input field has a super-basic but functional command history.
* ANSI color/style codes are, for the most part honored.
* Incomplete MCP/2.1 implementation -- mcp-notify is implemented, but mcp-cord is not, though the client lies and says it is.
* Starting in on MCP packages: dns-org-mud-moo-simpleedit -- currently it's hard-coded to launch gvim, but that'll be a preference later;  also dns-com-awns-status, which goes to STDERR.
* It breaks horribly if you try many of the menu items.
* Saving prefs now works, for the small set of prefs it honors.  As new prefs get added, they'll Just Work.


To do:
* Basic quality of life things like keyboard shortcuts.
* MCP 2.1 completed.  It does the version dance with the server (both the MCP version, and mcp-negotiate package-version), but ignores whatever it sees.  Also mcp-cord isn't implemented at all.
* Proper list of 'worlds' / accounts, MOOs, what-have-you.  Pondering schemes to scrape online MOO lists to offer suggestions.
* object browser, like MacMOOSE but hopefully nicer.
* inline MOO syntax highlighting?  Like, detect the output of "@list $player:tell" and auto-highlight it?
* Connections will hopefully have a 'connection type' -- currently thinking in terms of plain socket, SSL, and SSH port forwarding (automagic at connection time).

Things that aren't currently on the rader:
* tkMOO-light has a whole plugin architecture, and all sorts of third-party additions (I even wrote one, years ago).  I'm not delusional enough to think that there'll be a flourishing ecosystem of developers around **this** MOO client, so I'm not actually desigining with that in mind.
* I MOO socially, occasionally.  I don't do RPG MUDs or things like that, so I have no need for triggers and macros and so forth.  I don't even have a clear idea of what people do with them.

Guiding thoughts:
* Monospaced fonts and intuitive, pleasant uis are not inherently incompatible.
* There are a lot of wheels out there that have been invented well already.  My MOO client doesn't need its own text editor.  Lather, rinse, repeat.
* Nobody's living on a shell account on a VMS machine.  The MOO doesn't need to be a black-and-white culdesac.  There are dozens of interesting things a MOO client could do, connected to the 2013 Internet, that I haven't thought of yet.  Detect chat in a different language and offer to translate?  Tweet you when your friends log on?  Who knows.


(Aside, you could also check out my fork of tkMOO-light, [tkmoo-ttk](https://github.com/emersonrp/tkmoo-ttk), which moved lots of the innards of it to the ttk widget set, which was much more pleasant to look at.  I managed to break some stuff around the edges, though.  It's what I use day-to-day, until/unless this gets past the "toy" stage.)

Dependencies
------------

In addition to perl, wx, and the requisite "use Wx" glue, Module::ScanDeps (not itself a dependency) reports the following:

    'Carp'                  => '1.26',
    'Class::Accessor'       => '0.34',
    'Config::Simple'        => '4.59',
    'constant'              => '1.27',
    'Cwd'                   => '3.40',
    'Data::Dumper'          => '2.151',
    'Exporter'              => '5.68',
    'Exporter::Heavy'       => '5.68',
    'File::Path'            => '2.09',
    'File::Slurp'           => '9999.19',
    'File::Spec'            => '3.40',
    'File::Spec::Unix'      => '3.40',
    'File::Temp'            => '0.2301',
    'List::Util'            => '1.31',
    'parent'                => '0.228',
    'Scalar::Util'          => '1.31',
    'Socket'                => '2.013',
    'Text::ParseWords'      => '3.29',
    'threads'               => '1.92',
    'Wx'                    => '0.9921',
    'Wx::App'               => 'undef',
    'Wx::Event'             => 'undef',
    'Wx::Locale'            => 'undef',
    'Wx::Menu'              => 'undef',
    'Wx::Mini'              => '0.9921',
    'Wx::Print'             => '0.01',
    'Wx::RadioBox'          => 'undef',
    'Wx::RichText'          => '0.01',
    'Wx::Socket'            => '0.01',
    'Wx::Timer'             => 'undef',
    'Wx::Wx_Exp'            => 'undef',

Acknowledgements
----------------

* wxmoo is inspired by (and occasionally directly borrows from) [Andrew Wilson](http://www.awns.com)'s [tkMOO-light](http://www.awns.com/tkMOO-light), which is still probably the most-capable and -advanced MOO client around.
* [PADRE](http://padre.perlide.org) is not something I use, being a [vim](http://www.vim.org) junkie, but their generously-licensed code for a production wxperl application has been an invaluable reference.
* [Daring Fireball](http://www.daringfireball.net)'s blog graciously supplied to the public domain the [URL-detecting regex](http://daringfireball.net/2010/07/improved_regex_for_matching_urls) that I adapted.



