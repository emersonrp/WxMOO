package WxMOO::Window::PrefsEditor;
use perl5i::2;

use Wx qw( :dialog :sizer :id :misc :notebook :font :colour :textctrl
            wxFNTP_USEFONT_FOR_LABEL wxFNTP_FONTDESC_AS_LABEL
            wxCLRP_USE_TEXTCTRL wxCLRP_SHOW_LABEL
);
use Wx::Event qw( EVT_BUTTON EVT_FONTPICKER_CHANGED EVT_COLOURPICKER_CHANGED );
use parent -norequire, 'Wx::PropertySheetDialog';

method new($class: $parent) {

    my $self = $class->SUPER::new( $parent, -1, '', wxDefaultPosition, wxDefaultSize, );

    $self->{'parent'} = $parent;

    my $book = $self->GetBookCtrl;

    # $self->{'page_1'} = Wx::Panel->new($book, -1, wxDefaultPosition, wxDefaultSize, );
    $self->{'page_2'} = Wx::Panel->new($book, -1, wxDefaultPosition, wxDefaultSize, );
    $self->{'page_3'} = Wx::Panel->new($book, -1, wxDefaultPosition, wxDefaultSize, );

    $self->{'sizer'}        = Wx::BoxSizer->new(wxVERTICAL);
    $self->{'button_sizer'} = $self->CreateButtonSizer( wxOK | wxCANCEL );

    # $book->AddPage($self->{'page_1'}, "General");
    $book->AddPage($self->{'page_2'}, "Fonts and Colors");
    $book->AddPage($self->{'page_3'}, "Paths and Dirs");

    $self->populateFontPanel;

    $self->{'sizer'}->Add($book, 1, wxEXPAND | wxFIXED_MINSIZE | wxALL , 5 );
    $self->{'sizer'}->Add($self->{'button_sizer'}, 0, wxALIGN_CENTER_HORIZONTAL|wxBOTTOM, 5);

    $self->SetSizer($self->{'sizer'});

    $self->Centre(wxBOTH);

    EVT_BUTTON($self, wxID_OK, \&update_prefs);

    return $self;
}

method update_prefs($evt) {
    WxMOO::Prefs->prefs->output_font($self->{'page_2'}->{'ofont_ctrl'}->GetSelectedFont);
    WxMOO::Prefs->prefs->input_font( $self->{'page_2'}->{'ifont_ctrl'}->GetSelectedFont);

    WxMOO::Prefs->prefs->output_fgcolour($self->{'page_2'}->{'o_fgcolour_ctrl'}->GetColour);
    WxMOO::Prefs->prefs->output_bgcolour($self->{'page_2'}->{'o_bgcolour_ctrl'}->GetColour);
    WxMOO::Prefs->prefs->input_fgcolour( $self->{'page_2'}->{'i_fgcolour_ctrl'}->GetColour);
    WxMOO::Prefs->prefs->input_bgcolour( $self->{'page_2'}->{'i_bgcolour_ctrl'}->GetColour);

    WxMOO::Prefs->prefs->save;

    $self->{'parent'}->{'output_pane'}->restyle_thyself;
    $self->{'parent'}->{'input_pane'}->restyle_thyself;
    $evt->Skip;
}

method populateFontPanel {
    # fonts and colors
    my $fcp = $self->{'page_2'};

    my $ofont = WxMOO::Prefs->prefs->output_font || wxNullFont;
    my $ifont = WxMOO::Prefs->prefs->input_font  || wxNullFont;

    my $o_fgcolour = WxMOO::Prefs->prefs->output_fgcolour || wxBLACK;
    my $o_bgcolour = WxMOO::Prefs->prefs->output_bgcolour || wxWHITE;
    my $i_fgcolour = WxMOO::Prefs->prefs->input_fgcolour  || wxBLACK;
    my $i_bgcolour = WxMOO::Prefs->prefs->input_bgcolour  || wxWHITE;

    $fcp->{'o_sample'} = Wx::TextCtrl      ->new($fcp, -1, "",     wxDefaultPosition, wxDefaultSize, wxTE_READONLY);
    $fcp->{'ofont_ctrl' }   = Wx::FontPickerCtrl->new($fcp, -1, $ofont, wxDefaultPosition, wxDefaultSize,
                                                                            wxFNTP_FONTDESC_AS_LABEL|wxFNTP_USEFONT_FOR_LABEL);

    my $button_size = $fcp->{'ofont_ctrl'}->GetSize->GetHeight;

    $fcp->{'o_fgcolour_ctrl' } = Wx::ColourPickerCtrl->new($fcp, -1, $o_fgcolour, wxDefaultPosition, [$button_size, $button_size]);
    $fcp->{'o_bgcolour_ctrl' } = Wx::ColourPickerCtrl->new($fcp, -1, $o_bgcolour, wxDefaultPosition, [$button_size, $button_size]);

    $fcp->{'o_sample'}->SetFont($ofont);
    $fcp->{'o_sample'}->SetBackgroundColour($o_bgcolour);
    $fcp->{'o_sample'}->SetForegroundColour($o_fgcolour);
    $fcp->{'o_sample'}->SetValue(qq|Haakon says, "This is the output window."|);

    $fcp->{'i_sample'}  = Wx::TextCtrl      ->new($fcp, -1, "",     wxDefaultPosition, wxDefaultSize, wxTE_READONLY);
    $fcp->{'ifont_ctrl' }   = Wx::FontPickerCtrl->new($fcp, -1, $ifont, wxDefaultPosition, wxDefaultSize,
                                                                            wxFNTP_FONTDESC_AS_LABEL|wxFNTP_USEFONT_FOR_LABEL);
    $fcp->{'i_fgcolour_ctrl' } = Wx::ColourPickerCtrl->new($fcp, -1, $i_fgcolour, wxDefaultPosition, [$button_size, $button_size]);
    $fcp->{'i_bgcolour_ctrl' } = Wx::ColourPickerCtrl->new($fcp, -1, $o_bgcolour, wxDefaultPosition, [$button_size, $button_size]);

    $fcp->{'i_sample'}->SetFont($ifont);
    $fcp->{'i_sample'}->SetBackgroundColour($i_bgcolour);
    $fcp->{'i_sample'}->SetForegroundColour($i_fgcolour);
    $fcp->{'i_sample'}->SetValue(qq|`Haakon Hello from the input window.|);

    $fcp->{'output_sizer'} = Wx::FlexGridSizer->new(1, 3, 5, 10);
    $fcp->{'output_sizer'}->Add($fcp->{'ofont_ctrl'      }, 0, wxEXPAND, 0);
    $fcp->{'output_sizer'}->Add($fcp->{'o_fgcolour_ctrl' }, 0);
    $fcp->{'output_sizer'}->Add($fcp->{'o_bgcolour_ctrl' }, 0);
    $fcp->{'output_sizer'}->AddGrowableCol(0);
    $fcp->{'output_sizer'}->Fit($fcp);

    $fcp->{'input_sizer'} = Wx::FlexGridSizer->new(1, 3, 5, 10);
    $fcp->{'input_sizer'}->Add($fcp->{'ifont_ctrl'      }, 0, wxEXPAND, 0);
    $fcp->{'input_sizer'}->Add($fcp->{'i_fgcolour_ctrl' }, 0);
    $fcp->{'input_sizer'}->Add($fcp->{'i_bgcolour_ctrl' }, 0);
    $fcp->{'input_sizer'}->AddGrowableCol(0);
    $fcp->{'input_sizer'}->Fit($fcp);

    $fcp->{'panel_sizer'} = Wx::BoxSizer->new(wxVERTICAL);
    $fcp->{'panel_sizer'}->Add($fcp->{'o_sample'}, 1, wxRIGHT|wxLEFT|wxTOP|wxEXPAND, 10);
    $fcp->{'panel_sizer'}->Add($fcp->{'output_sizer'},  0, wxRIGHT|wxLEFT|wxEXPAND, 10);
    $fcp->{'panel_sizer'}->AddSpacer($button_size);
    $fcp->{'panel_sizer'}->Add($fcp->{'i_sample'},  1, wxRIGHT|wxLEFT|wxBOTTOM|wxEXPAND, 10);
    $fcp->{'panel_sizer'}->Add($fcp->{'input_sizer'},   0, wxRIGHT|wxLEFT|wxEXPAND, 10);

    EVT_FONTPICKER_CHANGED  ($fcp, $fcp->{'ofont_ctrl'}, \&update_sample_text);
    EVT_FONTPICKER_CHANGED  ($fcp, $fcp->{'ifont_ctrl'}, \&update_sample_text);
    EVT_COLOURPICKER_CHANGED($fcp, $fcp->{'i_fgcolour_ctrl'}, \&update_sample_text);
    EVT_COLOURPICKER_CHANGED($fcp, $fcp->{'i_bgcolour_ctrl'}, \&update_sample_text);
    EVT_COLOURPICKER_CHANGED($fcp, $fcp->{'o_fgcolour_ctrl'}, \&update_sample_text);
    EVT_COLOURPICKER_CHANGED($fcp, $fcp->{'o_bgcolour_ctrl'}, \&update_sample_text);

    $fcp->SetSizer($fcp->{'panel_sizer'});
}

method update_sample_text($evt) {
    for my $l ('o','i') {
        $self->{"${l}_sample"}->SetFont($self->{"${l}font_ctrl"}->GetSelectedFont);
        $self->{"${l}_sample"}->SetForegroundColour($self->{"${l}_fgcolour_ctrl"}->GetColour);
        $self->{"${l}_sample"}->SetBackgroundColour($self->{"${l}_bgcolour_ctrl"}->GetColour);
    }
    $evt->Skip;
}
