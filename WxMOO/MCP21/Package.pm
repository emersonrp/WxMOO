package WxMOO::MCP21::Package;
use perl5i::2;

use parent "Class::Accessor::Fast";
use parent -norequire, "Wx::EvtHandler";
WxMOO::MCP21::Package->mk_accessors( qw( package version message callback ) );

method new($class: $args) {
    my $self = Wx::EvtHandler->new;
    while (my($k, $v) = each %$args) {
        $self->{$k} = $v;
    }
    bless $self, $class;
}
