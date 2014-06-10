#!/usr/bin/perl
use strict;
use Test::More;

BEGIN { use_ok('WxMOO::Window::Main'); }

my $main = new_ok('WxMOO::Window::Main');

done_testing;
