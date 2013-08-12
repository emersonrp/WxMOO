package WxMOO::Window::PrefsEditor;
use perl5i::2;

use Wx qw( :dialog :sizer :id :misc :notebook );
use Wx::Event qw( EVT_BUTTON );
use parent -norequire, 'Wx::Dialog';
use WxMOO::Utility qw( id );

method new($class: $parent) {

    my $self = $class->SUPER::new(
        $parent, id('PREFS_EDITOR'), '',
        wxDefaultPosition, wxDefaultSize,
    );

    $self->{'notebook'}        = Wx::Notebook->new($self, -1, wxDefaultPosition, wxDefaultSize, 0);
    $self->{'notebook_page_1'} = Wx::Panel->new($self->{'notebook'}, -1, wxDefaultPosition, wxDefaultSize, );
    $self->{'notebook_page_2'} = Wx::Panel->new($self->{'notebook'}, -1, wxDefaultPosition, wxDefaultSize, );
    $self->{'notebook_page_3'} = Wx::Panel->new($self->{'notebook'}, -1, wxDefaultPosition, wxDefaultSize, );

    $self->{'sizer_staticbox'} = Wx::StaticBox->new($self, -1, "" );
    $self->{'sizer'}           = Wx::StaticBoxSizer->new($self->{'sizer_staticbox'}, wxVERTICAL);
    $self->{'button_sizer'}    = $self->CreateButtonSizer( wxOK | wxCANCEL );

    $self->{'notebook'}->AddPage($self->{'notebook_page_1'}, "General");
    $self->{'notebook'}->AddPage($self->{'notebook_page_2'}, "Fonts and Colors");
    $self->{'notebook'}->AddPage($self->{'notebook_page_3'}, "Paths and Dirs");

    $self->{'sizer'}->Add($self->{'notebook'}, 1, wxEXPAND | wxFIXED_MINSIZE, );
    $self->{'sizer'}->Add($self->{'button_sizer'}, 0, wxTOP | wxALIGN_CENTER_HORIZONTAL, 5);

    $self->SetSizer($self->{'sizer'});

    $self->Layout();

    return $self;
}
