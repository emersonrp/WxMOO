package WxMOO::MCP21::Package::dns_org_mud_moo_simpleedit;
use perl5i::2;

use parent 'WxMOO::MCP21::Package';

method new($class:) {
    my $self = $class->SUPER::new({
        package => 'dns-org-mud-moo-simpleedit',
        version => 1.0,
    });

    $WxMOO::MCP21::registry->register($self, qw( dns-org-mud-moo-simpleedit-content ));
}

method dispatch($message) {
    given ($message->{'message'}) {
        when ('dns-org-mud-moo-simpleedit-content') {
            $self->dns_org_mud_moo_simpleedit_content($message);
        }
    }
}

method dns_org_mud_moo_simpleedit_content { say STDERR "do_mcp_negotitate_can called with @_"; }
