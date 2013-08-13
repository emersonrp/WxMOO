package WxMOO::MCP21::Package;
use perl5i::2;

use parent "Class::Accessor::Fast";
WxMOO::MCP21::Package->mk_accessors( qw( package version message callback ) );

method new($class: $args) { bless $args, $class; }
