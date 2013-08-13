package WxMOO::MCP21::Package::mcp_cord;
use perl5i::2;

use parent 'WxMOO::MCP21::Package';

method new($class:) {
    my $self = $class->SUPER::new({
        package => 'mcp-cord',
        version => 1.0,
    });
    $WxMOO::MCP21::registry->register($self, qw( mcp-cord mcp_cord mcp-cord-open ));
}

method dispatch($message) {
    given ($message->{'message'}) {
        when ( /mcp-cord/ )        { $self->do_mcp_cord($message); }
        when ( /mcp-cord-open/ )   { $self->do_mcp_cord_open($message); }
        when ( /mcp-cord-closed/ ) { $self->do_mcp_cord_closed($message); }
    }
}
method do_mcp_cord        { say STDERR "do_mcp_cord called with @_"; }
method do_mcp_cord_open   { say STDERR "do_mcp_cord_open called with @_"; }
method do_mcp_cord_closed { say STDERR "do_mcp_cord_closed called with @_"; }
