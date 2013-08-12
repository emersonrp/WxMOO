package WxMOO::Window::WorldsList;
use perl5i::2;

use Wx qw( :misc :dialog :sizer );

use WxMOO::Prefs;

use base qw(Wx::Dialog);

method new($class: $parent) {

    my $self = $class->SUPER::new(
        $parent, -1, 'Worlds List',
        wxDefaultPosition, wxDefaultSize,
    );
    $self->{'world_details_staticbox'} = Wx::StaticBox->new($self, -1, "" );
    $self->{'world_details_box'}       = Wx::StaticBoxSizer->new($self->{'world_details_staticbox'}, wxHORIZONTAL);

    $self->{'world_label'}        = Wx::StaticText->new($self, -1, "World", wxDefaultPosition, wxDefaultSize, );
    $self->{'world_picker'}       = Wx::Choice->new($self, -1, wxDefaultPosition, wxDefaultSize, [], );
    $self->{'world_picker_sizer'} = Wx::BoxSizer->new(wxHORIZONTAL);
    $self->{'world_picker_sizer'}->Add($self->{'world_label'}, 0, wxALIGN_CENTER_VERTICAL|wxADJUST_MINSIZE, 0);
    $self->{'world_picker_sizer'}->Add($self->{'world_picker'}, 1, wxLEFT|wxALIGN_CENTER_VERTICAL|wxADJUST_MINSIZE, 5);

    $self->{'world_details_panel'} = Wx::Panel->new($self, -1, wxDefaultPosition, [400, 300], );
    $self->{'world_details_box'}->Add($self->{'world_details_panel'}, 1, wxEXPAND, 0);

    $self->{'button_sizer'} = $self->CreateButtonSizer( wxOK | wxCANCEL );

    $self->{'main_sizer'} = Wx::BoxSizer->new(wxVERTICAL);
    $self->{'main_sizer'}->Add($self->{'world_picker_sizer'}, 0, wxEXPAND | wxLEFT | wxRIGHT, 10);
    $self->{'main_sizer'}->Add($self->{'world_details_box'},  1, wxEXPAND | wxLEFT | wxRIGHT, 10);
    $self->{'main_sizer'}->Add($self->{'button_sizer'},       0, wxEXPAND | wxALL,            10);

    $self->SetSizer($self->{'main_sizer'});
    $self->{'main_sizer'}->Fit($self);
    $self->Layout();

    return $self;
}
