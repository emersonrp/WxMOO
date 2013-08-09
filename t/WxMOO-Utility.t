#!/usr/bin/perl

use strict;
use Test::Most;

BEGIN { use_ok('WxMOO::Utility') }

my $asdf_id = WxMOO::Utility::id('asdf');
ok($asdf_id, 'id returns something');

is(WxMOO::Utility::id('asdf'), $asdf_id, 'remembers previously-assigned id');

done_testing;
