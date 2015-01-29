#!/usr/bin/perl
use strict;
use Test::More;

BEGIN { use_ok 'WxMOO::Theme' }


my $theme = new_ok('WxMOO::Theme', [
    b_red   => 'ffeedd',
    d_twerk => 'eddead',
]);

my $red = $theme->Colour('red', 1);
isa_ok($red, 'Wx::Colour', "Theme returns bright colour as expected");
is($red->Red,   hex('ff'), 'Color has expected Red value');
is($red->Green, hex('ee'), 'Color has expected Green value');
is($red->Blue,  hex('dd'), 'Color has expected Blue value');

my $twerk = $theme->Colour('twerk');
isa_ok($red, 'Wx::Colour', "Theme returns dim colour as expected");
is($twerk->Red,   hex('ed'), 'Color has expected Red value');
is($twerk->Green, hex('de'), 'Color has expected Green value');
is($twerk->Blue,  hex('ad'), 'Color has expected Blue value');


done_testing;
