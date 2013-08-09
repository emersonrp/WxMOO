#!/usr/bin/perl
use strict;
use Test::Most;

BEGIN { use_ok "WxMOO::Window"; }

my $window = new_ok('WxMOO::Window');


done_testing;
