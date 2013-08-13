package WxMOO::MCP21::Package::mcp;
use perl5i::2;

use parent 'WxMOO::MCP21::Package';

method new($class:) {
    my $self = $class->SUPER::new({
        package => 'mcp',
        version => 2.1,
    });

    $WxMOO::MCP21::registry->register($self, qw(mcp : *));
}

method do_colon   { say STDERR "do_colon called with @_"; }
method do_splat   { say STDERR "do_splat called with @_"; }

method dispatch($message) {
    given ($message->{'message'}) {
        when ( /mcp/ ) { $self->do_mcp($message); }
        when ( /\*/  ) { $self->do_splat($message); }
        when ( /:/   ) { $self->do_colon($message); }
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

    for my $p ($WxMOO::MCP21::registry->packages) {
        next if $p->{'package'} eq 'mcp';
        WxMOO::MCP21::server_notify("mcp-negotiate-can", {
            'package'     => $p->{'package'},
            'min-version' => $p->{'min'} || "1.0",
            'max-version' => $p->{'max'} || "1.0"
        });
    }
    WxMOO::MCP21::server_notify('mcp-negotiation-end');
}
