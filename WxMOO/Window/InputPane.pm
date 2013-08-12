package WxMOO::Window::InputPane;
use perl5i::2;

use Wx qw( :misc :textctrl :font WXK_UP WXK_DOWN );
use Wx::Event qw( EVT_TEXT EVT_TEXT_ENTER EVT_CHAR );
use WxMOO::Prefs;
use WxMOO::Utility qw( id );

use base qw( Wx::TextCtrl Class::Accessor::Fast );
WxMOO::Window::InputPane->mk_accessors(qw( parent connection cmd_history ));

method new($class: $parent, $connection) {

    my $self = $class->SUPER::new( $parent, id('INPUT_PANE'), "",
        wxDefaultPosition, wxDefaultSize,
        wxTE_PROCESS_ENTER | wxTE_MULTILINE
    );

    $self->parent($parent);
    $self->connection($connection);

    my $font = WxMOO::Prefs->prefs->input_font;
    $self->SetFont($font);

    $self->cmd_history(WxMOO::Window::InputPane::CommandHistory->new);

    EVT_TEXT_ENTER( $self, -1, \&send_to_connection );
    EVT_TEXT      ( $self, -1, \&update_command_history );
    EVT_CHAR      ( $self,     \&check_command_history );

    $self->SetFocus;
    $self->Clear;

    bless $self, $class;
}

method send_to_connection {
    my $stuff = $self->GetValue;
    $self->cmd_history->add($stuff);
    $self->connection->output("$stuff\n");
    $self->Clear;
}

method update_command_history { $self->cmd_history->update($self->GetValue) }

method check_command_history($evt) {
    my $k = $evt->GetKeyCode;
    if ($k == WXK_UP) {
        $self->SetValue($self->cmd_history->prev);
    } elsif ($k == WXK_DOWN) {
        $self->SetValue($self->cmd_history->next);
    } else {
        $evt->Skip and return;
    }
    $self->SetInsertionPointEnd;
}

######################
package WxMOO::Window::InputPane::CommandHistory;
use perl5i::2;

# Rolling our own simplified command history here b/c Term::Readline
# et al are differently-supported on different platforms.  We only
# need a small subset anyway.

# we keep a list of historical entries, and a 'cursor' so we can
# keep track of where we are looking in the list.  The last
# entry in the history gets twiddled as we go.  Once we are done
# with it and enter it into history, a fresh '' gets appended to
# the array, on and on, world without end.
method new($class:) {
    bless {
        'history' => [''],
        'current' => 0,
    }, $class;
}

method end { $#{$self->{'history'}} }

# which entry does our 'cursor' point to?
method current_entry ($new) {
    $self->{'history'}->[$self->{'current'}] = $new if $new;
    $self->{'history'}->[$self->{'current'}];
}

method prev {
    $self->{'current'}-- if $self->{'current'} > 0;
    $self->current_entry;
}

method next {
    $self->{'current'}++ if $self->{'current'} < $self->end;
    $self->current_entry;
}

# if we've actually changed anything, take the changed value
# and use it as the new "current" value, at the end of the array.
method update($string) {
    if ($self->current_entry ne $string) {
        $self->{'current'} = $self->end;
        $self->current_entry($string);
    }
}

# this is the final state of the thing we input.
# Make sure it's updated, then push a fresh '' onto the end
method add($string) {
    return unless $string;  # don't stick blank lines in there.
    @{$self->{'history'}}[-1] = $string;

    push @{$self->{'history'}}, '';
    $self->{'current'} = $self->end;
}
