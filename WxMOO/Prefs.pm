package WxMOO::Prefs;
use perl5i::2;
use Wx qw( :font );
use Config::IniFiles;

use base 'Class::Singleton';

# TODO - cross-platform config file locater
my $FILENAME = "$ENV{'HOME'}/.wxmoorc";

method _new_instance($class: %init) {
        my $self = bless {%init}, $class;
        # TODO:  $self = get_my_prefs_from_storage;

        my $confFileExists = (-e $FILENAME);
        my $initialState = $confFileExists ? $FILENAME : initialDefaults();

        $self->{'cfg'} = Config::IniFiles->new(
            -file       => $initialState,
            -default    => 'default',
            -nocase     => 1,
            -allowempty => 1,
        );
        unless ($confFileExists) {
            $self->{'cfg'}->WriteConfig($FILENAME) or carp "couldn't write";
        }

        return $self;
}

# INITIAL DEFAULTS
{
    method input_font($new) {
        state $font //= Wx::Font->new($self->{'cfg'}->val('default','input_font'));
         if ($new) {
             $self->{'cfg'}->setval('default','input_font', $new);
             $font->SetNativeFontInfo($new);
         }
        return $font;
    }

    method output_font($new) {
        state $font //= Wx::Font->new($self->{'cfg'}->val('default','output_font'));
         if ($new) {
             $self->{'cfg'}->setval('default','output_font', $new);
             $font->SetNativeFontInfo($new);
         }
        return $font;
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
