package WxMOO::Prefs;
use perl5i::2;
use Wx qw( :font );
use Config::Simple '-strict';

use base 'Config::Simple';

# TODO - cross-platform config file locater
my $FILENAME = "$ENV{'HOME'}/.wxmoorc";

method prefs($class:) {
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

method save { $self->write($FILENAME) or carp "can't write config file: $!"; }

### Massager-accessors; transform from config-file strings to useful data
method input_font($new) {
    state $font //= Wx::Font->new($self->param('input_font'));
    if ($new) {
        $self->param('input_font', $new);
        $font->SetNativeFontInfo($new);
    }
    return $font;
}

method output_font($new) {
    state $font //= Wx::Font->new($self->param('output_font'));
    if ($new) {
        $self->param('output_font', $new);
        $font->SetNativeFontInfo($new);
    }
    return $font;
}

method input_height($new) {
    state $height //= $self->param('input_height'); # TODO - should we determine this based on font size?
    if ($new) {
        $self->param('input_height', $new);
        $self->save;
    }
    return $height;
}

### DEFAULTS -- this will set everything to a default value if it's not already set.
#               This gives us both brand-new-file and add-new-params'-default-values
{
    my $defaultFont = Wx::Font->new( 10, wxTELETYPE, wxNORMAL, wxNORMAL );
    my $defaultFontString = $defaultFont->GetNativeFontInfo->ToString;
    my %defaults = (
        input_font   => $defaultFontString,
        output_font  => $defaultFontString,
        theme        => 'solarized',
        input_height => 25,
        use_ansi     => 1,
    );

    method get_defaults {
        while (my ($key,$val) = each %defaults) {
            $self->param($key, $val) unless $self->param($key);
        }
    }
}
