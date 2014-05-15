#!/usr/bin/perl
package WxMOO;

use strict;
use warnings;

require 5.014;

use Wx::Perl::Packager;
use Wx;
use parent 'Wx::App';

use WxMOO::Window::Main;

sub OnInit {
    my $frame = WxMOO::Window::Main->new;
    $frame->Show(1);
    $frame->Initialize;
    shift->SetTopWindow($frame);
    return 1;
}

__PACKAGE__->run( @ARGV ) unless caller();

sub run { WxMOO->new->MainLoop; }

1;

__END__
