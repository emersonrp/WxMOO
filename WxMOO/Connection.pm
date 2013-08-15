package WxMOO::Connection;
use perl5i::2;

use Wx qw( :socket );
use Wx::Socket;
use Wx::Event qw( EVT_SOCKET_INPUT EVT_SOCKET_LOST EVT_SOCKET_CONNECTION );
use WxMOO::Utility qw( id );
use WxMOO::MCP21;  # this is icky

use parent -norequire, 'Wx::SocketClient';
use parent 'Class::Accessor::Fast';

WxMOO::Connection->mk_accessors(qw( host port ));

method new($class: $parent) {
    my $self = $class->SUPER::new;

    EVT_SOCKET_INPUT($parent, $self, \&onInput);
    EVT_SOCKET_LOST ($parent, $self, \&onClose);

    bless $self, $class;
}

method onInput {
    state $output //= Wx::Window::FindWindowById(id('OUTPUT_PANE'));
    my $poop = '';
    while ($self->Read($poop, 1, length $poop)) {
        last if $poop =~ /\n$/s;
    }
    $output->display($poop);
}

method onClose { }

method output { $self->Write(@_); }

method connect($host, $port) {
    $self->host( $host );
    $self->port( $port );

    $self->Connect($self->host, $self->port);

    # TODO - this is icky;  we'd much rather do this in an
    # mcp initialization step that auto-happens at connect time.
    $WxMOO::MCP21::connection = $self;

    carp "Can't connect to host/port" unless $self->IsConnected;
}

