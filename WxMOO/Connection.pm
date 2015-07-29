package WxMOO::Connection;
use strict;
use warnings;

use v5.14;
use Carp;

use Wx qw( :socket );
use Wx::Socket;
use Wx::Event qw( EVT_SOCKET_INPUT EVT_TIMER );
use WxMOO::MCP21;  # this is icky

use parent -norequire, 'Wx::SocketClient';
use parent 'Class::Accessor';

# TODO - should an output_pane own a connection, or vice-versa?
# This is related to the answer to "do we want multiple worlds to be
# open in like tabs or something?"
WxMOO::Connection->mk_accessors(qw( input_pane output_pane host port keepalive ));

sub new {
    my ($class, $parent) = @_;
    my $self = $class->SUPER::new;

    $self->output_pane($parent->{'output_pane'});
    $self->input_pane ($parent->{'input_pane'});
    EVT_SOCKET_INPUT($parent, $self, \&onInput);

    bless $self, $class;
}

sub onInput {
    my ($self) = @_;
    my $poop = '';
    while ($self->Read($poop, 1, length $poop)) {
        last if $poop =~ /\n$/s;
    }
    $self->output_pane->display($poop);
}

sub Close {
    my $self = shift;
    $self->keepalive->Stop;
    $self->SUPER::Close;
    $self->output_pane->display("WxMOO: Connection closed.\n");
}

sub output { shift->Write(@_); }

# $connection->connect ([host], [port])
#
# existing connections will remember their host and port if not supplied here,
# for ease of reconnect etc.
sub connect {
    my ($self, $host, $port) = @_;
    $self->host($host) if $host;
    $self->port($port) if $port;

    $self->Connect($self->host, $self->port);
    if ($self->IsConnected) {
        $self->input_pane->connection($self);

        # Ugh.  I'm gonna have to build my own event dispatch system, aren't I
        WxMOO::MCP21::new_connection($self);

        # TODO - 'if world->connection->keepalive'
        $self->init_keepalive;
    } else {
        carp "Can't connect to host/port";
    }
}

sub reconnect {
    my $self = shift;
    $self->Close if $self->IsConnected;
    $self->connect;
}

use constant KEEPALIVE_TIME => 60_000;  # 1 minute
sub init_keepalive {
    my $self = shift;
    $self->keepalive( WxMOO::Connection::Keepalive->new($self) );
    $self->keepalive->Start(KEEPALIVE_TIME, 0);
}


######################
# This is a stupid brute-force keepalive that periodically tickles the
# connection by sending a single space.  Not magical or brilliant.

package WxMOO::Connection::Keepalive;

use parent 'Wx::Timer';
use Wx::Event qw( EVT_TIMER );

sub new {
    my ($class, $connection) = @_;
    my $self = $class->SUPER::new;
    $self->{'connection'} = $connection;

    EVT_TIMER($self, -1, \&on_keepalive);

    bless $self, $class;
}

# TODO - this is pretty brute-force, innit?
# This'll likely break on worlds that actually
# are character-based instead of line-based.
sub on_keepalive {
    shift->{'connection'}->Write(" ");
}

1;
