package WxMOO::Window::OutputPane;
use perl5i::2;

use Wx qw( :richtextctrl :font );
use Wx::RichText;
use WxMOO::Utility qw( id );

use base 'Wx::RichTextCtrl';

method new($class: $parent) {
    my $self = $class->SUPER::new(
        $parent, id('OUTPUT_PANE'), "", [-1, -1], [400,300], wxRE_READONLY );

    # TODO - get this font from prefs
    my $testFont = Wx::Font->new( 12, wxTELETYPE, wxNORMAL, wxNORMAL );
    $self->SetFont($testFont);

    return bless $self, $class;
}

method AppendText {
    $self->SUPER::AppendText(@_);
    # TODO:  "if we want scroll-on-output or are already at the bottom..."
    $self->ShowPosition($self->GetCaretPosition);
}

1;
