package WxMOO::Connection;
use strict;
use warnings;

use v5.14;
use Carp;

use Wx qw( :socket );
use Wx::Socket;
use Wx::Event qw( EVT_SOCKET_INPUT EVT_SOCKET_LOST EVT_SOCKET_CONNECTION );
use WxMOO::Utility qw( id );
use WxMOO::MCP21;  # this is icky

use parent -norequire, 'Wx::SocketClient';
use parent 'Class::Accessor::Fast';

WxMOO::Connection->mk_accessors(qw( host port ));

sub new {
    my ($class, $parent) = @_;
    my $self = $class->SUPER::new;

    EVT_SOCKET_INPUT($parent, $self, \&onInput);
    EVT_SOCKET_LOST ($parent, $self, \&onClose);

    bless $self, $class;
}

sub onInput {
    my ($self) = @_;
    state $output //= Wx::Window::FindWindowById(id('OUTPUT_PANE'));
    my $poop = '';
    while ($self->Read($poop, 1, length $poop)) {
        last if $poop =~ /\n$/s;
    }
    $output->display($poop);
}

sub onClose { }

sub output { shift->Write(@_); }

sub connect {
    my ($self, $host, $port) = @_;
    $self->host( $host );
    $self->port( $port );

    $self->Connect($self->host, $self->port);

    WxMOO::MCP21::new_connection($self);

    carp "Can't connect to host/port" unless $self->IsConnected;
}

1;
