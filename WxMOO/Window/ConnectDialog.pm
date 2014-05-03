package WxMOO::Window::ConnectDialog;
use strict;
use warnings;
use v5.14;

use Wx qw( :id :misc :dialog :sizer );
use Wx::Event qw( EVT_BUTTON );
use base qw(Wx::Dialog);

sub new {
    my ($class, $parent) = @_;

    my $self = $class->SUPER::new( $parent, -1, "Connect to World",
       wxDefaultPosition, wxDefaultSize,
       wxDEFAULT_DIALOG_STYLE | wxSTAY_ON_TOP
    );

    $self->{'parent'} = $parent;

    $self->{'host_label'}   = Wx::StaticText->new($self, -1, "Host:");
    $self->{'host_field'}   = Wx::TextCtrl  ->new($self, -1, "");
    $self->{'port_label'}   = Wx::StaticText->new($self, -1, "Port:");
    $self->{'port_field'}   = Wx::TextCtrl  ->new($self, -1, "");

    $self->{'input_sizer'} = Wx::FlexGridSizer->new(2, 2, 0, 0);
    $self->{'input_sizer'}->AddGrowableCol( 1 );
    $self->{'input_sizer'}->Add($self->{'host_label'}, 0, wxLEFT | wxALIGN_RIGHT | wxALIGN_CENTER_VERTICAL, 10);
    $self->{'input_sizer'}->Add($self->{'host_field'}, 0, wxEXPAND | wxALL, 5);
    $self->{'input_sizer'}->Add($self->{'port_label'}, 0, wxLEFT | wxALIGN_RIGHT | wxALIGN_CENTER_VERTICAL, 10);
    $self->{'input_sizer'}->Add($self->{'port_field'}, 0, wxEXPAND | wxALL, 5);


    $self->{'button_sizer'} = $self->CreateButtonSizer( wxOK | wxCANCEL );

    $self->{'sizer'} = Wx::BoxSizer->new(wxVERTICAL);
    $self->{'sizer'}->Add($self->{'input_sizer'},  1, wxALL | wxEXPAND, 10);
    $self->{'sizer'}->Add($self->{'button_sizer'}, 0, wxALL, 10);
    $self->SetSizer($self->{'sizer'});
    $self->{'sizer'}->Fit($self);
    $self->Layout();
    $self->Centre(wxBOTH);

    EVT_BUTTON($self, wxID_OK, \&connect_please);

    return $self;
}

sub connect_please {
    my ($self, $evt) = @_;
    my $host = $self->{'host_field'}->GetValue;
    my $port = $self->{'port_field'}->GetValue;

    $self->{'host_field'}->Clear;
    $self->{'port_field'}->Clear;

    $self->{'parent'}->{'connection'}->connect($host, $port);
    $evt->Skip;
}

1;
