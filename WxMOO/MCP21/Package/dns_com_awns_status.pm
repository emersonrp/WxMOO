package WxMOO::MCP21::Package::dns_com_awns_status;
use strict;
use warnings;
use v5.14;

use Method::Signatures;
no if $] >= 5.018, warnings => "experimental::smartmatch";

use parent 'WxMOO::MCP21::Package';

method new($class:) {
    my $self = $class->SUPER::new({
        package => 'dns-com-awns-status',
        min     => '1.0',
        max     => '1.0',
    });

    $WxMOO::MCP21::registry->register($self, qw( dns-com-awns-status ));
    $self->_init;
}

method _init {
}
method dispatch($message) {
    given ($message->{'message'}) {
        when ('dns-com-awns-status') { $self->do_status($message); }
    }
}

method do_status($message) {
    say STDERR $message;
}

1;
