package WxMOO::MCP21::Package::mcp_negotiate;
use perl5i::2;

use parent 'WxMOO::MCP21::Package';

method new($class:) {
    my $self = $class->SUPER::new({
        package => 'mcp-negotiate',
        version => 2.0,
    });

    $WxMOO::MCP21::registry->register($self, qw( mpc-negotiate-can mcp_negotiate_end ));
}

method do_mcp_negotiate_can { say STDERR "do_mcp_negotitate_can called with @_"; }
method do_mcp_negotiate_end { say STDERR "do_mcp_negotitate_end called with @_"; }
