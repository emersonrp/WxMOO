#!/usr/bin/perl
use strict;
use Test::Most;

BEGIN { use_ok "WxMOO::Window::OutputPane"; }

my $window = new_ok('WxMOO::Window::OutputPane');


done_testing;
