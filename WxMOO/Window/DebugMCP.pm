package WxMOO::Window::DebugMCP;
use strict;
use warnings;
use v5.14;

use Wx qw( :misc :sizer );
use Wx::Event qw( EVT_SIZE );

use WxMOO::Prefs;
use WxMOO::Utility qw(id);

use base 'Wx::Frame';

sub new {
    my ($class) = @_;
    state $self;
    unless ($self) {
        $self = $class->SUPER::new( undef, id('DEBUG_MCP'), 'Debug MCP');

        $self->addEvents;

        if (1 || WxMOO::Prefs->prefs->save_mcp_window_size) {
            my $w = WxMOO::Prefs->prefs->window_width  || 600;
            my $h = WxMOO::Prefs->prefs->window_height || 400;
            $self->SetSize([$w, $h]);
        }

        $self->{'output_pane'} = WxMOO::Window::DebugMCP::Pane->new($self);
        $self->{'sizer'} = Wx::BoxSizer->new( wxVERTICAL );
        $self->{'sizer'}->Add($self->{'output_pane'}, 1, wxALL|wxGROW, 5);
        $self->SetSizer($self->{'sizer'});
    }

    return $self;
}

sub toggle_visible  {
    my $self = shift;
    if ($self->IsShown) {
        $self->Hide->();
        $self->active(0);
    } else {
        $self->Show->();
        $self->active(1);
    }
}
sub Close {
    my $self = shift;
    $self->SUPER::Close->();
    $self->active(0);
}

sub active {
    my ($self, $new) = @_;
    state $active;
    $active = $new if defined $new;
    return $active;
}

SCOPE: {
    my $serverMsgColour = Wx::Colour->new(128, 0, 0);
    my $clientMsgColour = Wx::Colour->new(0,   0, 128);
    sub display {
        my ($self, @data) = @_;
        return unless $self->active;

        my $op = $self->{'output_pane'};

        for my $line (@data) {
            unless ($line =~ /\n$/) { $line = "$line\n"; }

            if ($line =~ /^S->C/) {
                $op->BeginTextColour($serverMsgColour);
            } elsif ($line =~ /^C->S/) {
                $op->BeginTextColour($clientMsgColour);
            } else {
                $op->BeginBold;
            }
            $op->WriteText($line);
            $op->EndTextColour;
            $op->EndBold;
        }
        $op->ShowPosition($op->GetCaretPosition);
    }
}

sub addEvents {
    my ($self) = @_;

    EVT_SIZE( $self, \&onSize );
}

sub onSize {
    my ($self, $evt) = @_;

    if (1 || WxMOO::Prefs->prefs->save_mcp_window_size) {
        my ($w, $h) = $self->GetSizeWH;
        WxMOO::Prefs->prefs->mcp_window_width($w);
        WxMOO::Prefs->prefs->mcp_window_height($h);
        WxMOO::Prefs->prefs->save;
    }
    $evt->Skip;
}

package WxMOO::Window::DebugMCP::Pane;
use strict;
use warnings;
use v5.14;

use Wx qw( :misc :textctrl );
use Wx::RichText;

use WxMOO::Utility 'id';

use base 'Wx::RichTextCtrl';

sub new {
    my ($class, $parent) = @_;
    my $self = $class->SUPER::new(
        $parent, id('MCP_OUTPUT_PANE'), "", wxDefaultPosition, wxDefaultSize,
            wxTE_READONLY | wxTE_NOHIDESEL
        );

    $self->{'parent'} = $parent;

    return bless $self, $class;
}

1;
