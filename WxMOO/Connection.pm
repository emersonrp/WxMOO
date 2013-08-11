package WxMOO::Connection;
use perl5i::2;

use Wx qw( :socket );
use Wx::Socket;
use Wx::Event qw( EVT_SOCKET_INPUT EVT_SOCKET_LOST EVT_SOCKET_CONNECTION );
use WxMOO::Utility qw( id );

use base 'Wx::SocketClient';

method new($class: $parent) {
    my $self = $class->SUPER::new;

    EVT_SOCKET_INPUT($parent, $self, \&onInput);
    EVT_SOCKET_LOST ($parent, $self, \&onClose);

    bless $self, $class;
}

method onInput {
    state $output //= Wx::Window::FindWindowById(id('OUTPUT_PANE'));
    while ($self->Read(my $poop, 1024)) {
        $output->display($poop);
    }
}

method onClose { }

method output { $self->Write(@_); }

method host { 'hayseed.net' }
method port { '7777' }

method connect {
    $self->Connect($self->host, $self->port);
    carp "Can't connect to host/port" unless $self->IsConnected;
}

