package WxMOO::MCP21::Package;
use strict;
use warnings;
use v5.14;

use Method::Signatures;

use Wx;
use parent "Class::Accessor::Fast";
use parent -norequire, "Wx::EvtHandler";
WxMOO::MCP21::Package->mk_accessors( qw( package min max message callback activated ) );

method new($class: $args) {
    my $self = Wx::EvtHandler->new;
    while (my($k, $v) = each %$args) {
        $self->{$k} = $v;
    }
    bless $self, $class;
}

method _init { }

1;
