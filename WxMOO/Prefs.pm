package WxMOO::Prefs;
use strict;
use warnings;
use v5.14;

use Carp;
use Wx qw( :font :colour );
use Config::Simple '-strict';

use base qw(Config::Simple);

# TODO - cross-platform config file locater
my $FILENAME = "$ENV{'HOME'}/.wxmoorc";

sub prefs {
    my ($class) = @_;
    state $self;

    unless ($self) {
        $self = $class->SUPER::new( syntax => 'ini' );
        bless $self, $class;

        if (my $confFileExists = (-e $FILENAME)) {
            # read it in from the file
            $self->read($FILENAME);
        }
        $self->get_defaults;
        $self->autosave(1);
    };
    return $self;
}

sub save { shift->write($FILENAME) or carp "can't write config file: $!"; }

### Massager-accessors; transform from config-file strings to useful data
sub input_font {
    my ($self, $new) = @_;
    state $font //= Wx::Font->new($self->param('input_font'));
    if ($new) {
        $font = $new;
        $self->param('input_font', $new->GetNativeFontInfoDesc);
    }
    return $font;
}

sub output_font {
    my ($self, $new) = @_;
    state $font //= Wx::Font->new($self->param('output_font'));
    if ($new) {
        $font = $new;
        $self->param('output_font', $new->GetNativeFontInfoDesc);
    }
    return $font;
}

sub input_height {
    my ($self, $new) = @_;
    state $height //= $self->param('input_height'); # TODO - should we determine this based on font size?
    if ($new) {
        $height = $new;
        $self->param('input_height', $new);
        $self->save;
    }
    return $height;
}

sub output_fgcolour {
    my ($self, $new) = @_;
    state $colour //= Wx::Colour->new($self->param('output_fgcolour'));
    if ($new) {
        $colour = $new;
        $self->param('output_fgcolour', $new->GetAsString(wxC2S_HTML_SYNTAX));
    }
    return $colour;
}

sub output_bgcolour {
    my ($self, $new) = @_;
    state $colour //= Wx::Colour->new($self->param('output_bgcolour'));
    if ($new) {
        $colour = $new;
        $self->param('output_bgcolour', $new->GetAsString(wxC2S_HTML_SYNTAX));
    }
    return $colour;
}

sub input_fgcolour {
    my ($self, $new) = @_;
    state $colour //= Wx::Colour->new($self->param('input_fgcolour'));
    if ($new) {
        $colour = $new;
        $self->param('input_fgcolour', $new->GetAsString(wxC2S_HTML_SYNTAX));
    }
    return $colour;
}

sub input_bgcolour {
    my ($self, $new) = @_;
    state $colour //= Wx::Colour->new($self->param('input_bgcolour'));
    if ($new) {
        $colour = $new;
        $self->param('input_bgcolour', $new->GetAsString(wxC2S_HTML_SYNTAX));
    }
    return $colour;
}

sub use_mcp {
    my ($self, $new) = @_;
    $self->param('use_mcp', $new) if defined $new;
    $self->param('use_mcp');
}

sub use_ansi {
    my ($self, $new) = @_;
    $self->param('use_ansi', $new) if defined $new;
    $self->param('use_ansi');
}

### DEFAULTS -- this will set everything to a default value if it's not already set.
#               This gives us both brand-new-file and add-new-params'-default-values
{
    my $defaultFont = Wx::Font->new( 10, wxTELETYPE, wxNORMAL, wxNORMAL );
    my $defaultFontString = $defaultFont->GetNativeFontInfo->ToString;
    my %defaults = (
        input_font      => $defaultFontString,
        output_font     => $defaultFontString,
        output_fgcolour => wxBLACK->GetAsString(wxC2S_HTML_SYNTAX),
        output_bgcolour => wxWHITE->GetAsString(wxC2S_HTML_SYNTAX),
        input_fgcolour  => wxBLACK->GetAsString(wxC2S_HTML_SYNTAX),
        input_bgcolour  => wxWHITE->GetAsString(wxC2S_HTML_SYNTAX),
        theme           => 'solarized',
        input_height    => 25,
        use_ansi        => 1,
        use_mcp         => 1,
    );

    sub get_defaults {
        my ($self) = @_;
        while (my ($key,$val) = each %defaults) {
            $self->param($key, $val) unless defined $self->param($key);
        }
    }
}

1;
