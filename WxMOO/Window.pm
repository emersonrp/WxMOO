package WxMOO::Window;
use perl5i::2;

use Wx qw();

use parent -norequire, 'Wx::Frame';

# We want various flavors of windows:
#   main
#   editor
#   preferences
#   worlds
#   MCP trace/debug
#   help
#   various dialogs
#
# These should all be subclasses, I guess.

sub new {
    my $class = shift;

    my $self = $class->SUPER::new( undef, -1, 'WxMOO' );

    return $self;
}

"The truth will set you free";
