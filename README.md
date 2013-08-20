WxMOO
=====

Perl/Wx MOO client.  Very pre-alpha.  It's intended to run on Windows, MacOS, and Linux/etc.  Currently it can't be properly said to run on any of them.

This is a response to Andrew Wilson's fantastic [tkMOO-light](http://www.awns.com/tkMOO-light) MOO client being basically abandoned, and tk-based, which is uugly, and coded in TCL which I find eye-stabbingly difficult to work with.  So I thought I'd see if I could reproduce the 75% of it that I use, in Perl which I understand, and Wx which looks like something even remotely from the 21st century, and so forth.

Done:
* It connects to a MOO.  Initially, hard-coded to my MOO at hayseed.net:7777, specifically, but the Worlds->Connect dialog now works to connect wherever you like.
* It takes input, and shows output.  Almost pleasantly, even.
* The input field has a super-basic but functional command history.
* ANSI color/style codes are, for the most part honored.
* Partial MCP/2.1 implementation, along with dns-org-mud-moo-simpleedit -- currently it's hard-coded to launch gvim, but that'll be a preference later
* It breaks horribly if you try many of the menu items.


To do:
* Basic quality of life things like keyboard shortcuts.
* Saving prefs, fonts, colors, sizes, etc.  Themes are on the roadmap.
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
============

In addition to perl, wx, and the requisite "use Wx" glue, this currently uses [perl5i](http://search.cpan.org/~mschwern/perl5i-v2.12.0/lib/perl5i.pm), mostly because I wanted to try it out.  That drags in an immense number of dependencies, so I hope to pare it back down later to just the parts I actually use.

If you like CPAN for all things Perl, just:

    cpan install perl5i

...and it should dtrt.

I develop in Fedora, and I try to keep as much stuff as possible curated via the rpm system, so I have a list below of the packages I installed via RPM and the ones that I had to go to CPAN for.  YMMV.



CPAN autobox::dump
CPAN autodie
CPAN Text::Exception::LessClever
CPAN Carp::Fix::1\_25
CPAN CLASS
CPAN Exporter::Declare
CPAN ExtUtils::Depends
CPAN Fatal
CPAN Fennec
CPAN Hash::StoredIterator
CPAN Meta::Builder
CPAN Mock::Quick
CPAN Object::ID
CPAN Parallel::Runner
CPAN perl5i
CPAN Perl6::Caller
CPAN Test::Exception::LessClever
CPAN Test::Output
CPAN Test::Workflow
CPAN utf8::all

perl-Algorithm-Dependency
perl-Algorithm-Diff
perl-Archive-Tar
perl-Archive-Zip
perl-autobox
perl-autobox-Core
perl-autobox-List-Util
perl-autovivification
perl-B-Hooks-EndOfScope
perl-B-Hooks-OP-Check
perl-Cache
perl-Capture-Tiny
perl-Child
perl-Class-Accessor
perl-Class-Accessor-Chained
perl-Class-Data-Inheritable
perl-Class-Inspector
perl-Class-Load
perl-Class-Singleton
perl-Config-Tiny
perl-Data-Optlist
perl-Date-ISO8601
perl-Date-Manip
perl-DateTime
perl-DateTime-Locale
perl-DateTime-TimeZone
perl-DateTime-TimeZone-SystemV
perl-DateTime-TimeZone-Tzfile
perl-Devel-Declare
perl-Devel-StackTrace
perl-Dist-CheckConflicts
perl-Email-Date-Format
perl-Exception-Class
perl-ExtUtils-CBuilder
perl-File-chdir
perl-File-Copy-Recursive
perl-File-HomeDir
perl-File-Listing
perl-File-Which
perl-Hash-FieldHash
perl-Hash-Merge-Simple
perl-HTTP-Cookies
perl-HTTP-Daemon
perl-HTTP-Negotiate
perl-Import-Info
perl-IO-Zlib
perl-IPC-Cmd
perl-IPC-Run3
perl-IPC-System-Simple
perl-JSON
perl-JSON-PP
perl-libwww-perl
perl-Locale-Maketext-Simple
perl-Log-Dispatch
perl-Log-Dispatch-FileRotate
perl-Log-Log4perl
perl-Mail-Sender
perl-Mail-Sendmail
perl-MailTools
perl-MIME-Lite
perl-MIME-Types
perl-Modern-Perl
perl-Module-Depends
perl-Module-Implementation
perl-Module-Load
perl-Module-Load-Conditional
perl-Module-Runtime
perl-Net-SMTP-SSL
perl-Package-Constants
perl-Package-Stash
perl-Package-Stash-XS
perl-Params-Check
perl-Params-Classify
perl-Params-Validate
perl-Perl-OSType
perl-Probe-Perl
perl-Scope-Guard
perl-Sub-Exporter
perl-Sub-Install
perl-Sub-Name
perl-Sys-Syslog
perl-Term-ReadLine-Perl
perl-Test-ClassAPI
perl-Test-Deep
perl-Test-Diff
perl-Test-Differences
perl-Test-Fatal
perl-Test-Most
perl-Test-NoWarnings
perl-Test-Output
perl-Test-Requires
perl-Test-Tester
perl-Tree-DAG\_Node
perl-Try-Tiny
perl-Variable-Magic
perl-version
perl-Version-Requirements
perl-Want
perl-WWW-RobotRules
perl-WWW-RobotRules
perl-XML-DOM
perl-XML-Parser
perl-XML-RegExp
perl-YAML
rrdtool
rrdtool-perl

