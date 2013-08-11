package WxMOO::Prefs;
use perl5i::2;
use Wx qw( :font );

use base 'Class::Singleton';

method _new_instance($class: %init) {
        my $self = bless {%init}, $class;
        # TODO:  $self = get_my_prefs_from_storage;

# TODO this is hard-coded for now until we actually save prefs
my $font= Wx::Font->new( 10, wxTELETYPE, wxNORMAL, wxNORMAL );
$self->input_font($font);
$self->output_font($font);

        return $self;
}
# TODO - represent this internally as:
# $prefs = { saved => { font => 'stan', love => 'like oxygen',... },
#            current => { font => 'something else',...}
# }
# so we can know if the prefs are 'dirty' and need saving, and
# also 'revert to saved'

method input_font($new) {
    $self->{'input_font'} = $new if $new;
    $self->{'input_font'};
}

method output_font($new) {
    $self->{'output_font'} = $new if $new;
    $self->{'output_font'};
}
