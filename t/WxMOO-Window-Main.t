#!/usr/bin/perl
use strict;
use Test::Most;

BEGIN { use_ok('WxMOO::Window::Main'); }

my $main = new_ok('WxMOO::Window::Main');

done_testing;
