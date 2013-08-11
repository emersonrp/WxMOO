package WxMOO::Window::OutputPane;
use perl5i::2;

use Wx qw( :richtextctrl :font );
use Wx::RichText;
use Wx::Event qw( EVT_SET_FOCUS );
use WxMOO::Prefs;
use WxMOO::Utility qw( id );

# TODO remove when plugins work
use WxMOO::Plugins::ANSI;

use base 'Wx::RichTextCtrl';

method new($class: $parent) {
    my $self = $class->SUPER::new(
        $parent, id('OUTPUT_PANE'), "", [-1, -1], [400,300], wxRE_READONLY );

    $self->{'parent'} = $parent;
    my $font = WxMOO::Prefs->instance->output_font;
    $self->SetFont($font);

    EVT_SET_FOCUS($self, \&focus_input);

    return bless $self, $class;
}

method AppendText {
    $self->SUPER::AppendText(@_);
    # TODO:  "if we want scroll-on-output or are already at the bottom..."
    $self->ShowPosition($self->GetCaretPosition);
}

method display ($text) {
    if (1 or $WxMOO::Preferences::UseANSI) {
        my $stuff = WxMOO::Plugins::ANSI::output_filter($text);
        for my $bit (@$stuff) {
            if (ref $bit) {
                $self->BeginStyle($bit);
            } else {
                $self->AppendText($bit);
            }
        }
    } else {
        $self->AppendText($text);
    }
}

method focus_input {
    # TODO - make this a little less intrusive
    my $input_field = Wx::Window::FindWindowById(id('INPUT_PANE'));
    $input_field->SetFocus if $input_field;
}
