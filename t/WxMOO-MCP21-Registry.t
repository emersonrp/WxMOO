use strict;
use Test::Most;
use WxMOO::MCP21::Package;

BEGIN { use WxMOO::MCP21::Registry; }

my $registry = new_ok('WxMOO::MCP21::Registry');

my $package = WxMOO::MCP21::Package->new({
    package => "test",
    min => "1.0",
    max => "2.0",
});

$registry->register($package, qw( msg1 msg2 whee ));

is_deeply($registry->get_package('test'), $package,
    "correctly registers and finds new packages");

is_deeply($registry->package_for_message('whee'), $package,
    "correctly finds packages by the messages they register.");
is($registry->package_for_message('bogus'), undef,
    "correctly returns no package for unknown messages");

is($registry->get_best_version('test','1.0','1.0'), '1.0',
    "offers the correct version when server max > client max");
is($registry->get_best_version('test','2.0','3.0'), '2.0',
    "offers the correct version when client max > server max");
is($registry->get_best_version('test','3.0','3.0'), undef,
    "correctly returns undef when no version match is found");


done_testing;
