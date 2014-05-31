#!/usr/bin/perl
package WxMOO;

use strict;
use warnings;

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

WxMOO->new->MainLoop;

1;

