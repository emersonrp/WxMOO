#!/usr/bin/perl
use strict;
use Test::Most;

BEGIN { use_ok "WxMOO::Window::InputPane"; }

my $window = new_ok('WxMOO::Window::InputPane');


done_testing;
