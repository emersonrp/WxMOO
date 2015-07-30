package WxMOO::Window::Main::ContextMenu;
use strict;
use warnings;
use v5.14;

use Wx qw( :misc :id );
use Wx::Event qw(EVT_MENU);

use parent -norequire, qw( Class::Accessor );
WxMOO::Window::Main::ContextMenu->mk_accessors(qw( parent menu output_pane input_pane ));

sub new {
    my ($class, $parent) = @_;

    my $self = bless {}, $class;

    $self->menu(Wx::Menu->new);
    $self->parent($parent);
    $self->output_pane($self->parent->output_pane);
    $self->input_pane($self->parent->input_pane);

    $self->menu->Append(wxID_CUT,    '');
    $self->menu->Append(wxID_COPY,   '');
    $self->menu->Append(wxID_PASTE,  '');
    $self->menu->Append(wxID_DELETE, '');

    EVT_MENU( $self, wxID_CUT,    \&handleCut   );
    EVT_MENU( $self->menu, wxID_COPY,   \&handleCopy  );
    EVT_MENU( $self->menu, wxID_PASTE,  \&handlePaste );
    EVT_MENU( $self->menu, wxID_DELETE, \&handleDelete );

    return $self;
}

sub Popup {
    my ($self, $evt, $target) = @_;
    # Wow really?  Is this the right way to do this?
    my $p = $evt->GetEventObject->ScreenToClient($evt->GetPosition);
    $target->PopupMenu($self->menu, $p);
}

sub handleCopy  {
    my ($self) = @_;
    if    ($self->output_pane->HasSelection) { $self->output_pane->Copy }
    elsif ($self-> input_pane->HasSelection) { $self-> input_pane->Copy }
}
sub handleCut   { shift->input_pane->Cut }
sub handlePaste { shift->input_pane->Paste }
sub handleDelete { 1 }

1;
