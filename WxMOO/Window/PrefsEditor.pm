package WxMOO::Window::PrefsEditor;
use perl5i::2;

use Wx qw( :dialog :sizer :id :misc :notebook );
use Wx::Event qw( EVT_BUTTON );
use parent -norequire, 'Wx::PropertySheetDialog';
use WxMOO::Utility qw( id );

method new($class: $parent) {

    my $self = $class->SUPER::new(
        $parent, id('PREFS_EDITOR'), '',
        wxDefaultPosition, wxDefaultSize,
    );

    $self->{'page_1'} = Wx::Panel->new($self->GetBookCtrl, -1, wxDefaultPosition, wxDefaultSize, );
    $self->{'page_2'} = Wx::Panel->new($self->GetBookCtrl, -1, wxDefaultPosition, wxDefaultSize, );
    $self->{'page_3'} = Wx::Panel->new($self->GetBookCtrl, -1, wxDefaultPosition, wxDefaultSize, );

    $self->{'sizer'}        = Wx::BoxSizer->new(wxVERTICAL);
    $self->{'button_sizer'} = $self->CreateButtonSizer( wxOK | wxCANCEL );

    $self->GetBookCtrl->AddPage($self->{'page_1'}, "General");
    $self->GetBookCtrl->AddPage($self->{'page_2'}, "Fonts and Colors");
    $self->GetBookCtrl->AddPage($self->{'page_3'}, "Paths and Dirs");

    $self->{'sizer'}->Add($self->GetBookCtrl, 1, wxEXPAND | wxFIXED_MINSIZE | wxALL , 5 );
    $self->{'sizer'}->Add($self->{'button_sizer'}, 0, wxALIGN_CENTER_HORIZONTAL);

    $self->SetSizer($self->{'sizer'});

    $self->Layout();
    $self->Centre(wxBOTH);

    return $self;
}
