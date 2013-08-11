package WxMOO::Window::InputPane;
use perl5i::2;

use Wx qw( :misc :textctrl :font );
use Wx::Event qw( EVT_TEXT_ENTER );
use WxMOO::Prefs;
use WxMOO::Utility qw( id );

use base 'Wx::TextCtrl';

method new($class: $parent) {

    my $self = $class->SUPER::new( $parent, id('INPUT_PANE'), "",
        wxDefaultPosition, wxDefaultSize,
        wxTE_PROCESS_ENTER | wxTE_MULTILINE
    );

    $self->{'parent'} = $parent;

    my $font = WxMOO::Prefs->instance->input_font;
    $self->SetFont($font);

    EVT_TEXT_ENTER( $self, -1, \&send_to_connection );

    $self->SetFocus;
    $self->Clear;

    bless $self, $class;
}

method send_to_connection {
    my $stuff = $self->GetValue;
    # TODO - having to stash 'parent' away to get the connection seems w0rng.
    $self->{'parent'}->connection->output("$stuff\n");
    $self->Clear;
}

1;
