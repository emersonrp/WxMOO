#!/usr/bin/perl
use strict;
use Test::More;

BEGIN { use_ok "WxMOO::Window::Main::OutputPane"; }

my $window = new_ok('WxMOO::Window::Main::OutputPane');


done_testing;
