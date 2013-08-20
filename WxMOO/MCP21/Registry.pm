package WxMOO::MCP21::Registry;
use perl5i::2;

method new($class:) {
    bless {
        registry => {},
        packages => {},
    }, $class;
}

method register($package, @messages) {
    unless ($package->isa('WxMOO::MCP21::Package')) {
        carp "something not a package tried to register with the mcp registry";
        return;
    }
    $self->{'packages'}->{$package->{'package'}} = $package;
    for my $message (@messages) {
        $self->{'registry'}->{$message} = $package;
    }
}

method get_package { $self->{'packages'}->{shift()} }

method packages { values %{$self->{'packages'}} }

method package_for_message($message) { $self->{'registry'}->{$message}; }


# next two subs taken from MCP 2.1 specification, section 2.4.3
method get_best_version($package, $smin, $smax) {
    return unless grep { $_->{'package'} eq $package } $self->packages;
    my $cmax = $self->{'packages'}->{$package}->max;
    my $cmin = $self->{'packages'}->{$package}->min;
    return
        (_version_cmp($cmax, $smin) and _version_cmp($smax, $cmin)) ?
        (_version_cmp($smax, $cmax) ? $cmax : $smax)                :
        undef;
}

func _version_cmp ($v1, $v2) {
    my @v1 = split /\./, $v1;
    my @v2 = split /\./, $v2;

    return ($v1[0] > $v2[0] or ($v1[0] == $v2[0] and $v1[1] >= $v2[1]));
}
