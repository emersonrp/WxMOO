package WxMOO::Window::OutputPane;
use perl5i::2;

use Wx qw( :misc :richtextctrl );
use Wx::RichText;
use Wx::Event qw( EVT_SET_FOCUS );

use WxMOO::Prefs;
use WxMOO::Utility qw( id );

# TODO we need a better output_filter scheme, probably?
use WxMOO::ANSI;
use WxMOO::MCP21;

use base 'Wx::RichTextCtrl';

method new($class: $parent) {
    my $self = $class->SUPER::new(
        $parent, id('OUTPUT_PANE'), "", wxDefaultPosition, wxDefaultSize, wxRE_READONLY );

    $self->{'parent'} = $parent;
    my $font = WxMOO::Prefs->prefs->output_font;
    $self->SetFont($font);

    EVT_SET_FOCUS($self, \&focus_input);

    return bless $self, $class;
}

method AppendText {
    $self->SUPER::AppendText(@_);
    $self->ScrollIfAppropriate;
}

method ScrollIfAppropriate {
    # TODO:  "if we want scroll-on-output or are already at the bottom..."
    $self->ShowPosition($self->GetCaretPosition);
}

method display ($text) {
    for my $line (split /\n/, $text) {
        if (1 or WxMOO::Prefs->prefs->use_mcp) {
            next unless ($line = WxMOO::MCP21::output_filter($line));
        }
        if (1 or WxMOO::Prefs->prefs->use_ansi) {
            my $stuff = WxMOO::ANSI::output_filter($line);
            $line = '';
            for my $bit (@$stuff) {
                if (ref $bit) {
                    $self->BeginStyle($bit);
                } else {
                    $line .= $bit;
                }
            }
        }
        $self->AppendText($line);
    }
}

method focus_input {
    # TODO - make this a little less intrusive
    my $input_field = Wx::Window::FindWindowById(id('INPUT_PANE'));
    $input_field->SetFocus if $input_field;
}
