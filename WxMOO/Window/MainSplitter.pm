package WxMOO::Window::MainSplitter;
use strict;
use warnings;
use v5.14;

use Wx qw( :misc :splitterwindow );
use Wx::Event qw( EVT_SIZE EVT_SPLITTER_SASH_POS_CHANGED );

use WxMOO::Prefs;
use WxMOO::Utility qw(id);

use base "Wx::SplitterWindow";

sub new {
    my ($class, $parent) = @_;
    my $self = $class->SUPER::new($parent, id('SPLITTER'),
        wxDefaultPosition, wxDefaultSize,
        wxSP_3D | wxSP_LIVE_UPDATE
    );
    EVT_SPLITTER_SASH_POS_CHANGED( $self, $self, \&saveSplitterSize );
    EVT_SIZE( $self, \&HandleResize );

    return $self;
}

sub saveSplitterSize {
    my ($self, $evt) = @_;
    my ($w, $h)  = $self->GetSizeWH;
    WxMOO::Prefs->prefs->input_height( $h - $evt->GetSashPosition );
}

sub HandleResize {
    my ($self, $evt) = @_;
    my ($w, $h)  = $self->GetSizeWH;
    my $InputHeight = WxMOO::Prefs->prefs->input_height;
    $self->SetSashPosition($h - $InputHeight, 'resize');
    $self->GetWindow1->ScrollIfAppropriate;
}

1;
