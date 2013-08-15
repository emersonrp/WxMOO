#!/usr/bin/perl
package WxMOO;
use perl5i::2;

require 5.014;

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

__END__
