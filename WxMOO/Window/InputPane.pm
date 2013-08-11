package WxMOO::Window::InputPane;
use perl5i::2;

use Wx qw( :misc :textctrl :font );
use Wx::Event qw( EVT_TEXT_ENTER );
use WxMOO::Utility qw( id );

use base 'Wx::TextCtrl';

method new($class: $parent) {

    my $self = $class->SUPER::new( $parent, id('INPUT_PANE'), "",
        wxDefaultPosition, wxDefaultSize,
        wxTE_PROCESS_ENTER
    );

    $self->{'parent'} = $parent;

    # TODO - get this font from prefs
    my $testFont = Wx::Font->new( 12, wxTELETYPE, wxNORMAL, wxNORMAL );
    $self->SetFont($testFont);

    EVT_TEXT_ENTER( $self, -1, \&send_to_connection );

    $self->SetFocus;
    $self->Clear;

    bless $self, $class;
}

method send_to_connection {
    my $stuff = $self->GetValue;
    $self->{'parent'}->connection->output("$stuff\n");
    $self->Clear;
}

1;
