package WxMOO::Window::PrefsEditor;
use perl5i::2;

use Wx qw( :misc :notebook );
use parent -norequire, 'Wx::Notebook';
use WxMOO::Utility qw( id );

method new($class: $parent) {
    state $count;
    my $self = $class->SUPER::new(
        $parent, id('PREFS_EDITOR'), wxDefaultPosition, wxDefaultSize,
        wxNB_TOP | wxNB_FIXEDWIDTH);

    $self->AddPage(WxMOO::Window::PrefsPage->new, 'page ' . ++$count, 0, $count);


    return $self;
}


package WxMOO::Window::PrefsPage;
use perl5i::2;
use parent -norequire, 'Wx::Window';

method new($class: $parent, $name) {
    my $self = $class->SUPER::new($parent);

    bless $self, $class;

    $self->Name = $name;

    return $self;
}
