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
    $self->{'world_picker'}       = Wx::Choice    ->new($self, -1, wxDefaultPosition, wxDefaultSize, [], );
    $self->{'world_picker_sizer'} = Wx::BoxSizer->new(wxHORIZONTAL);
    $self->{'world_picker_sizer'}->Add($self->{'world_label'},  0,        wxALIGN_CENTER_VERTICAL, 0);
    $self->{'world_picker_sizer'}->Add($self->{'world_picker'}, 1, wxLEFT|wxALIGN_CENTER_VERTICAL, 5);

    $self->{'world_details_panel'} = WxMOO::Window::WorldPanel->new($self);
    $self->{'world_details_box'}->Add($self->{'world_details_panel'}, 1, wxEXPAND, 0);

    $self->{'button_sizer'} = $self->CreateButtonSizer( wxOK | wxCANCEL );

    $self->{'main_sizer'} = Wx::BoxSizer->new(wxVERTICAL);
    $self->{'main_sizer'}->Add($self->{'world_picker_sizer'}, 0, wxEXPAND | wxALL,            10);
    $self->{'main_sizer'}->Add($self->{'world_details_box'},  1, wxEXPAND | wxLEFT | wxRIGHT, 10);
    $self->{'main_sizer'}->Add($self->{'button_sizer'},       0, wxEXPAND | wxALL,            10);

    $self->SetSizer($self->{'main_sizer'});
    $self->{'main_sizer'}->Fit($self);
    $self->Layout();

    $self->Centre(wxBOTH);

    return $self;
}





package WxMOO::Window::WorldPanel;
use perl5i::2;

use Wx qw( :misc :sizer :textctrl );

use WxMOO::Prefs;
# use WxMOO::Prefs::World;

use base qw(Wx::Panel);

method new($class: $parent) {

    my $self = $class->SUPER::new( $parent, -1,
        wxDefaultPosition, wxDefaultSize,
        # $style,
    );

    $self->{'name_label'}     = Wx::StaticText->new($self, -1, "Name:",     wxDefaultPosition, wxDefaultSize, );
    $self->{'name_field'}     = Wx::TextCtrl  ->new($self, -1, "",          wxDefaultPosition, wxDefaultSize, );
    $self->{'host_label'}     = Wx::StaticText->new($self, -1, "Host:",     wxDefaultPosition, wxDefaultSize, );
    $self->{'host_field'}     = Wx::TextCtrl  ->new($self, -1, "",          wxDefaultPosition, wxDefaultSize, );
    $self->{'port_label'}     = Wx::StaticText->new($self, -1, "Port:",     wxDefaultPosition, wxDefaultSize, );
    $self->{'port_field'}     = Wx::TextCtrl  ->new($self, -1, "",          wxDefaultPosition, wxDefaultSize, );
    $self->{'username_label'} = Wx::StaticText->new($self, -1, "Username:", wxDefaultPosition, wxDefaultSize, );
    $self->{'username_field'} = Wx::TextCtrl  ->new($self, -1, "",          wxDefaultPosition, wxDefaultSize, );
    $self->{'password_label'} = Wx::StaticText->new($self, -1, "Password:", wxDefaultPosition, wxDefaultSize, );
    $self->{'password_field'} = Wx::TextCtrl  ->new($self, -1, "",          wxDefaultPosition, wxDefaultSize, wxTE_PASSWORD);
    $self->{'type_label'}     = Wx::StaticText->new($self, -1, "Type", wxDefaultPosition, wxDefaultSize, );
    $self->{'type_picker'}    = Wx::Choice    ->new($self, -1, wxDefaultPosition, wxDefaultSize,
                                                        ['Socket','SSL','SSH Forwarding'], );
    $self->{'type_picker'}->SetSelection(0);
    $self->{'field_sizer'} = Wx::FlexGridSizer->new(5, 2, 5, 10);
    $self->{'field_sizer'}->Add($self->{'name_label'},     0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL, 0);
    $self->{'field_sizer'}->Add($self->{'name_field'},     0, wxEXPAND, 0);
    $self->{'field_sizer'}->Add($self->{'host_label'},     0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL, 0);
    $self->{'field_sizer'}->Add($self->{'host_field'},     0, wxEXPAND, 0);
    $self->{'field_sizer'}->Add($self->{'port_label'},     0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL, 0);
    $self->{'field_sizer'}->Add($self->{'port_field'},     0, wxEXPAND, 0);
    $self->{'field_sizer'}->Add($self->{'username_label'}, 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL, 0);
    $self->{'field_sizer'}->Add($self->{'username_field'}, 0, wxEXPAND, 0);
    $self->{'field_sizer'}->Add($self->{'password_label'}, 0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL, 0);
    $self->{'field_sizer'}->Add($self->{'password_field'}, 0, wxEXPAND, 0);
    $self->{'field_sizer'}->Add($self->{'type_label'},     0, wxALIGN_RIGHT|wxALIGN_CENTER_VERTICAL, 0);
    $self->{'field_sizer'}->Add($self->{'type_picker'},    0, wxEXPAND, 0);
    $self->{'field_sizer'}->AddGrowableCol(1);

    $self->{'notes_box_staticbox'} = Wx::StaticBox->new($self, -1, "Notes" );
    $self->{'notes_box'}           = Wx::StaticBoxSizer->new($self->{'notes_box_staticbox'}, wxHORIZONTAL);
    $self->{'notes_field'}         = Wx::TextCtrl->new($self, -1, "", wxDefaultPosition, wxDefaultSize, wxTE_MULTILINE);
    $self->{'notes_box'}->Add($self->{'notes_field'}, 1, wxEXPAND, 0);

    $self->{'mcp_check'}          = Wx::CheckBox->new($self, -1, "MCP 2.1",          wxDefaultPosition, wxDefaultSize, );
    $self->{'login_dialog_check'} = Wx::CheckBox->new($self, -1, "Use Login Dialog", wxDefaultPosition, wxDefaultSize, );
    $self->{'shortlist_check'}    = Wx::CheckBox->new($self, -1, "On Short List",    wxDefaultPosition, wxDefaultSize, );
    $self->{'checkbox_sizer'} = Wx::GridSizer->new(3, 2, 0, 0);
    $self->{'checkbox_sizer'}->Add($self->{'mcp_check'}, 0, wxLEFT|wxRIGHT|wxALIGN_CENTER_VERTICAL, 5);
    $self->{'checkbox_sizer'}->Add($self->{'login_dialog_check'}, 0, wxLEFT|wxRIGHT|wxALIGN_CENTER_VERTICAL, 5);
    $self->{'checkbox_sizer'}->Add($self->{'shortlist_check'}, 0, wxLEFT|wxRIGHT|wxALIGN_CENTER_VERTICAL, 5);

    $self->{'reset_button'} = Wx::Button->new($self, -1, "Reset");
    $self->{'apply_button'} = Wx::Button->new($self, -1, "Apply");
    $self->{'button_sizer'} = Wx::FlexGridSizer->new(1, 2, 0, 0);
    $self->{'button_sizer'}->Add($self->{'reset_button'}, 0, wxALL|wxALIGN_RIGHT, 5);
    $self->{'button_sizer'}->Add($self->{'apply_button'}, 0, wxALL, 5);
    $self->{'button_sizer'}->AddGrowableCol(0);

    $self->{'panel_sizer'} = Wx::BoxSizer->new(wxVERTICAL);
    $self->{'panel_sizer'}->Add($self->{'field_sizer'}, 0, wxALL|wxEXPAND, 10);
    $self->{'panel_sizer'}->Add($self->{'notes_box'}, 1, wxEXPAND, 0);
    $self->{'panel_sizer'}->Add($self->{'checkbox_sizer'}, 0, wxEXPAND, 0);
    $self->{'panel_sizer'}->Add($self->{'button_sizer'}, 0, wxEXPAND, 0);

    $self->SetSizer($self->{'panel_sizer'});
    $self->{'panel_sizer'}->Fit($self);

    return $self;
}
