package WxMOO::MCP21;
use perl5i::2;

use Storable qw(dclone);

use WxMOO::MCP21::Registry;

# This module was developed by squinting directly at both the MCP spec
# at http://www.moo.mud.org/mcp2/mcp2.html and tkMOO-light's plugins/mcp21.tcl
# file, to which this code bears more than a little resemblance and owes
# more than a little debt.

my $PREFIX       = qr/^#\$#/;
my $QUOTE_PREFIX = qr/^#\$"/;

# TODO - these -work- as package-scope vars, but might want some better encapsulation
# later on.  tkmoo has the notion of a request object that it stashes them in.
our $mcp_active = 0;
our $mcp_auth_key = '';
our $connection = '';

# This is probably the right place for this, though.
our $registry = WxMOO::MCP21::Registry->new;

# We'd like to enumerate this automatically.
use WxMOO::MCP21::Package::mcp;
use WxMOO::MCP21::Package::mcp_cord;
use WxMOO::MCP21::Package::mcp_negotiate;
my $pkg_mcp           = WxMOO::MCP21::Package::mcp          ->new;
my $pkg_mcp_cord      = WxMOO::MCP21::Package::mcp_cord     ->new;
my $pkg_mcp_negotiate = WxMOO::MCP21::Package::mcp_negotiate->new;

func output_filter($data) {

    # this is random frantic experimenting to get mcp fragments to stop appearing
    # in the in-band stuff.  Hypothesis:  multiple lines are filling the 1024-byte
    # read and then when it starts the next read, we're in the middle of a message.

    # MCP spec, 2.1:
    # A received network line that begins with the characters #$# is translated
    # to an out-of-band (MCP message) line consisting of exactly the same
    # characters.  A received network line that begins with the characters #$"
    # must be translated to an in-band line consisting of the network line with
    # the prefix #$" removed.  Any other received network line translates to an
    # in-band line consisting of exactly the same characters.

    if (
        (!($data =~ s/$PREFIX//))    # we had no prefix to trim off the front
            or
        ($data =~ s/$QUOTE_PREFIX//) # we had the quote prefix, and trimmed it

    ) { return $data; }

    # now we have only lines that started with $PREFIX, which has been trimmed

    say STDERR "S->C: #\$#$data";

    my ($message_name, $rest) = $data =~ /(\S+)\s*(.*)/;

    if (!$mcp_active and $message_name ne 'mcp') {
        # we haven't started yet, and the message isn't a startup negotiation
        return;
    }

    my $message = {};  # here's where we decode this
    # multi-line message handling.  Very TODO still
    if ($message_name eq '*') {
        my ($tag, $field, $value) = ($rest =~ /^ (\S*) ([^:]*): (.*)/);
        say STDERR "mcp - multiline message continuation";
        $message->{'_data_tag'} = $tag;
        $message->{'field'}     = $field;
        $message->{'value'}     = $value;
    } elsif ($message_name eq ':') {
        say STDERR "mcp - multiline message end";
        my ($tag) = ($rest =! /^ (\S+)/);
        $message->{'_data_tag'} = $tag;
    } else {
        $message = parse($rest);
    }

    # check auth
    if (($message_name ne '*')   and
        ($message_name ne 'mcp') and
        ($message->{'auth_key'} ne $mcp_auth_key)
    ) {
        say STDERR "mcp - auth failed";
        return;
    }

    $message->{'message'} = $message_name;

    if ($message->{'multiline'}) {
        # TODO - what is going on here?  Are we... stashing away the multiline lines between requests?
        say STDERR "mcp - multiline message start";
#         $tag = $message->{'_data_tag'};
#         $message->{'_message'} = $message_name;
#         $request{$tag} = dclone $request{'current'};
    }

    dispatch($message);

    # always return undef so the output widget skips this line
    return;
}

my $simpleChars = q|[-a-z0-9~`!@#$%^&*()=+{}[\]\|';?/><.,]|;

func parse($raw) {
    return unless $raw;
    my ($first) = split /\s+/, $raw;
    my $message = {};

    if ($first !~ /:$/) {
        $message->{'auth_key'} = $first;
        $raw =~ s/^$first\s+//;
    }
    while ($raw =~ /([-\*a-z0-9]+)           # keyword
                        :                       # followed by colon
                        \s+                     # some space
                        (                       # and either
                            (?:"[^"]+")         # a quoted string - TODO - the grammar is more picky than [^"]
                            |                   # or
                            (?:$simpleChars)+   # a value
                        )/igx)
    {
        my ($keyword, $value) = ($1, $2);
        if ($keyword =~ s/\*$//) {
            $message->{'data'}->{$keyword} ||= [];
            push @{$message->{'data'}->{$keyword}}, $value;
            $message->{'multiline'} = 1;
        } else {
            $message->{'data'}->{$keyword} = $value;
        }
    }
    return $message;
}

func dispatch($message) {
    # my $overlap = $registry->overlap;
    my $package = $registry->package_for_message($message->{'message'}) or return;
    # my $version = $package->version;

    # TODO need a better representation of the play among packages, versions, and messages
    # Meanwhile, let's assume versions are not a problem
    $package->dispatch($message);
}


func server_notify($msg, $args) {

    my $key = $WxMOO::MCP21::mcp_auth_key;

    my $out = "#\$#$msg $key ";

    while (my ($k, $v) = each %$args) {
        # TODO escape $v if needed
        $v //= '';
        $out .= "$k: $v ";
    }
    say STDERR "C->S: $out";
    $connection->Write("$out\n");
}

