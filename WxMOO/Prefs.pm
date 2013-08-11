package WxMOO::Prefs;
use perl5i::2;
use Wx qw( :font );
use Config::IniFiles;

use base qw(Class::Singleton Class::Accessor::Fast);
WxMOO::Prefs->mk_accessors(qw(cfg));

# TODO - cross-platform config file locater
my $FILENAME = "$ENV{'HOME'}/.wxmoorc";


# TODO - there's some objecty conflation here between the prefs 
# object and the config/ini object, which sorta want to be the same 
# thing instead of one inside the other.  TODO

method _new_instance($class: %init) {
        my $self = bless {%init}, $class;
        # TODO:  $self = get_my_prefs_from_storage;

        my $confFileExists = (-e $FILENAME);
        my $initialState = $confFileExists ? $FILENAME : initialDefaults();

        $self->cfg(Config::IniFiles->new(
            -file       => $initialState,
            -default    => 'default',
            -nocase     => 1,
            -allowempty => 1,
        ));
        unless ($confFileExists) { $self->save; }

        return $self;
}

method save {
    $self->cfg->WriteConfig($FILENAME) or carp "couldn't write";
}

# INITIAL DEFAULTS
{
    method input_font($new) {
        state $font //= Wx::Font->new($self->cfg->val('default','input_font'));
        if ($new) {
            $self->cfg->setval('default','input_font', $new);
            $font->SetNativeFontInfo($new);
        }
        return $font;
    }

    method output_font($new) {
        state $font //= Wx::Font->new($self->cfg->val('default','output_font'));
        if ($new) {
            $self->cfg->setval('default','output_font', $new);
            $font->SetNativeFontInfo($new);
        }
        return $font;
    }

    method input_height($new) {
        use Data::Dumper;
        state $height //= 20; # TODO - should we determine this based on font size?
        if ($new) {
            $self->cfg->setval('default', 'input_height', $new);
            $self->save;
        }
        return $height;
    }

    sub initialDefaults {
        my $defaultFont = Wx::Font->new( 10, wxTELETYPE, wxNORMAL, wxNORMAL );
        my $defaultFontString = $defaultFont->GetNativeFontInfo->ToString;

        return \"
[default]
input_font=$defaultFontString
output_font=$defaultFontString
"
    }
}
