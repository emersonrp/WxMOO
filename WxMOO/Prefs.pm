package WxMOO::Prefs;
use strict;
use warnings;
use v5.14;

use Carp;
use Scalar::Util 'blessed';
use Wx qw( :font :colour );

use parent 'Class::Accessor';
WxMOO::Prefs->mk_accessors(qw(
    use_mcp use_ansi highlight_urls
    save_window_size window_height window_width input_height
    save_mcp_window_size mcp_window_height mcp_window_width
    external_editor
));

sub prefs {
    my ($class) = @_;
    state $self;

    unless ($self) {
        $self = {'config' => Wx::ConfigBase::Get };

        bless $self, $class;

        $self->get_defaults;
    };
    return $self;
}

sub config { shift->{'config'} }

# these are 'get' and 'set' so Class::Accessor will automagically use them
sub get { shift->config->Read(@_); }
sub set {
    my ($self, $param, $val) = @_;
    $self->config->Write($param, $val);
    $self->config->Flush;
}

### Massager-accessors; transform from config-file strings to useful data

### FONTS
sub input_font  { shift->_font_param('input_font',  shift); }
sub output_font { shift->_font_param('output_font', shift); }

sub _font_param {
    my ($self, $param, $new) = @_;
    my $font;

    if (blessed $new and $new->isa('Wx::Font')) {
        $font = $new;
    } elsif (my $fontname = $new || $self->get($param)) {
        $font = Wx::Font->new( $fontname );
    }
    if ($font) {
        $self->set($param, $font->GetNativeFontInfo->ToString);
    }
    return $font;
}

### COLORS
sub input_bgcolour  { shift->_colour_param('input_bgcolour',  shift); }
sub input_fgcolour  { shift->_colour_param('input_fgcolour',  shift); }
sub output_bgcolour { shift->_colour_param('output_bgcolour', shift); }
sub output_fgcolour { shift->_colour_param('output_fgcolour', shift); }

sub _colour_param {
    my ($self, $param, $new) = @_;
    my $colour;

    if (blessed $new and $new->isa('Wx::Colour')) {
        $colour = $new;
    } elsif (my $colourname = $new || $self->get($param)) {
        $colour = Wx::Colour->new( $colourname );
    }
    if ($colour) {
        $self->set($param, $colour->GetAsString(wxC2S_HTML_SYNTAX));
    }
    return $colour;
}

### DEFAULTS -- this will set everything to a default value if it's not already set.
#               This gives us both brand-new-file and add-new-params'-default-values
{
    my $defaultFont = Wx::Font->new( 12, wxTELETYPE, wxNORMAL, wxNORMAL );
    my $defaultFontString = $defaultFont->GetNativeFontInfo->ToString;

    my %defaults = (
        input_font      => $defaultFontString,
        output_font     => $defaultFontString,
        output_fgcolour => '#839496',
        output_bgcolour => '#002b36',
        input_fgcolour  => '#839496',
        input_bgcolour  => '#002b36',

        save_window_size => 1,
        window_width     => 800,
        window_height    => 600,
        input_height     => 25,

        # theme          => 'solarized',
        use_ansi       => 1,
        use_mcp        => 1,
        highlight_urls => 1,

        save_mcp_window_size => 1,
        mcp_window_width     => 600,
        mcp_window_height    => 400,

        external_editor => 'gvim -f',
    );

    sub get_defaults {
        my ($self) = @_;
        while (my ($key,$val) = each %defaults) {
            $self->$key($val) unless $self->$key;
        }
    }
}

1;
