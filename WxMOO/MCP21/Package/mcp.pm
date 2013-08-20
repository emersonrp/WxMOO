package WxMOO::MCP21::Package::mcp;
use perl5i::2;

use parent 'WxMOO::MCP21::Package';

method new($class:) {
    my $self = $class->SUPER::new({
        activated => 1,
        package   => 'mcp',
        min       => 2.1,
        max       => 2.1,
    });

    $WxMOO::MCP21::registry->register($self, qw(mcp));
}

method dispatch($message) {
    given ($message->{'message'}) {
        when ( /mcp/ ) { $self->do_mcp($message); }
    }
}

### handlers
method do_mcp($args) {

    if ($args->{'data'}->{'version'}+0 == 2.1 or $args->{'data'}->{'to'}+0 >= 2.1) {
        $WxMOO::MCP21::mcp_active = 1;
    } else {
        say STDERR "mcp version doesn't match, bailing";
        return;
    }

    # we both support 2.1 - ship the server a key and start haggling
    my $key = $WxMOO::MCP21::mcp_auth_key = $$;
    $WxMOO::MCP21::connection->Write("#\$#mcp authentication-key: $key version: 2.1 to: 2.1\n");
    say STDERR "C->S: #\$#mcp authentication-key: $key version: 2.1 to: 2.1";

    WxMOO::MCP21::start_mcp();

}

method do_splat($args) {
    # all taken care of in MCP21.pm
}

method do_colon($args) {
    # all taken care of in MCP21.pm
}
