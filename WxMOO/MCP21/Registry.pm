package WxMOO::MCP21::Registry;
use perl5i::2;

# this is a grab-bag of badness, mostly used as a placeholder as we suss out
# how perl wants to have the packages stored.

method new($class:) { bless { registry =>  {} }, $class; }

method register($package, @messages) {
    unless ($package->isa('WxMOO::MCP21::Package')) {
        carp "something not a package tried to register with the mcp registry";
        return;
    }
    $self->{'packages'} //= [];
    push @{$self->{'packages'}}, $package;
    for my $message (@messages) {
        $self->{'registry'}->{'message'}->{$message} = $package;
    }
}

method packages { @{$self->{'packages'}} }

method package_for_message($message) {
    return unless $message;
    $self->{'registry'}->{'message'}->{$message};
}

