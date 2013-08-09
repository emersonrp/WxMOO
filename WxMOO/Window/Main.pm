package WxMOO::Window::Main;
use perl5i::2;

use parent 'WxMOO::Window';

use Wx qw(:sizer);
use Wx::Event qw( EVT_MENU );
use WxMOO::Connection;  # Might go away later
use WxMOO::Window::InputPane;
use WxMOO::Window::OutputPane;
use WxMOO::Utility qw(id);

method new($class: %args) {
    my $self = $class->SUPER::new( %args );

    my $WorldsMenu = Wx::Menu->new;
    $WorldsMenu->Append(id('MENUITEM_WORLDS'), "Worlds...", "");
    $WorldsMenu->Append(id('MENUITEM_OPEN'), "Open...", "");
    $WorldsMenu->Append(id('MENUITEM_CLOSE'), "Close", "");
    $WorldsMenu->AppendSeparator;
    $WorldsMenu->Append(id('MENUITEM_QUIT'), "Quit", "");

    my $EditMenu = Wx::Menu->new;
    $EditMenu->Append(id('MENUITEM_CUT'), "Cut", "");
    $EditMenu->Append(id('MENUITEM_COPY'), "Copy", "");
    $EditMenu->Append(id('MENUITEM_PASTE'), "Paste", "");
    $EditMenu->Append(id('MENUITEM_CLEAR'), "Clear", "");

    my $PrefsMenu = Wx::Menu->new;
    $PrefsMenu->Append(id('MENUITEM_PREFS'), "Edit Preferences", "");

    my $HelpMenu = Wx::Menu->new;
    $HelpMenu->Append(id('MENUITEM_HELP'), "Help Topics", "");
    $HelpMenu->Append(id('MENUITEM_ABOUT'), "About WxMOO", "");

    my $MenuBar = Wx::MenuBar->new;
    $MenuBar->Append($WorldsMenu, "Worlds");
    $MenuBar->Append($EditMenu, "Edit");
    $MenuBar->Append($PrefsMenu, "Preferences");
    $MenuBar->Append($HelpMenu, "Help");

    $self->SetMenuBar($MenuBar);

    # MENUBAR EVENTS
    EVT_MENU( $self, id('MENUITEM_WORLDS'), sub {1} );
    EVT_MENU( $self, id('MENUITEM_OPEN'),   sub {1} );
    EVT_MENU( $self, id('MENUITEM_CLOSE'),  sub {1} );
    EVT_MENU( $self, id('MENUITEM_QUIT'),   \&quitApplication );

    EVT_MENU( $self, id('MENUITEM_CUT'),    sub {1} );
    EVT_MENU( $self, id('MENUITEM_COPY'),   sub {1} );
    EVT_MENU( $self, id('MENUITEM_PASTE'),  sub {1} );
    EVT_MENU( $self, id('MENUITEM_CLEAR'),  sub {1} );

    EVT_MENU( $self, id('MENUITEM_PREFS'),  sub {1} );

    EVT_MENU( $self, id('MENUITEM_HELP'),   sub {1} );
    EVT_MENU( $self, id('MENUITEM_ABOUT'),  \&showAboutBox );

    my $OutputPane = WxMOO::Window::OutputPane->new($self);
    my $InputPane  = WxMOO::Window::InputPane ->new($self);

    my $Sizer = Wx::BoxSizer->new( wxVERTICAL );
    $Sizer->Add($OutputPane, 1, wxALL|wxGROW, 5);
    $Sizer->Add($InputPane, 0, wxALL|wxGROW, 5);
    $self->SetSizer($Sizer);

    ### don't keep this here
    my $sock = WxMOO::Connection->new($self);
    $sock->connect;
    $self->{'current_connection'} = $sock;

    return $self;
}

method connection { $self->{'current_connection'} }

method showAboutBox { Wx::AboutBox(our $aboutDialogInfo) }

method quitApplication { $self->Close(1); }
