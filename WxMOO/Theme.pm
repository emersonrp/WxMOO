package WxMOO::Theme;
use strict;
use warnings;
use v.5.14;

sub new {
    my ($class, %args) = @_;
    bless {
        b_black   => '002b36',
        d_black   => '073642',
        b_red     => 'dc322f',
        d_red     => 'cb4b16',
        b_green   => '859900',
        d_green   => '586e75',
        b_yellow  => 'b58900',
        d_yellow  => '657b83',
        b_blue    => '268bd2',
        d_blue    => '839496',
        b_magenta => 'd33682',
        d_magenta => '6c71c4',
        b_cyan    => '2aa198',
        d_cyan    => '93a1a1',
        b_white   => 'eee8d5',
        d_white   => 'fdf6e3',
    }, $class;
}

sub get_color {
    my ($self, $color, $brightness) = @_;
    $brightness = $brightness ? substr($brightness, 0, 1) : 'd';
    $self->{"${brightness}_$color"};
}

sub get_wxColour {
    my ($self, $color, $brightness) = @_;
    my $c = $self->get_color(@_);
    my @rgb = map $_ / 255, unpack 'C*', pack 'H*', $c;
    return Wx::Colour->new(@rgb);
}

1;
