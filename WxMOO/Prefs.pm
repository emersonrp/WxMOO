package WxMOO::Prefs;
use perl5i::2;
use Wx qw( :font );

use base 'Class::Singleton';

method _new_instance($class: %init) {
        say STDERR "ok, creating the singleton";
        my $self = bless {%init}, $class;
        # TODO:  $self = get_my_prefs_from_storage;

# TODO this is hard-coded for now until we actually save prefs
my $font= Wx::Font->new( 10, wxTELETYPE, wxNORMAL, wxNORMAL );
$self->input_font($font);
$self->output_font($font);

        return $self;
}

method input_font($new) {
    $self->{'input_font'} = $new if $new;
    $self->{'input_font'};
}

method output_font($new) {
    $self->{'output_font'} = $new if $new;
    $self->{'output_font'};
}
