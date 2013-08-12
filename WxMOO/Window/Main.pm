package WxMOO::Window::Main;
use perl5i::2;

use Wx qw( :misc :sizer );
use Wx::Event qw( EVT_MENU );
use WxMOO::Connection;  # Might go away later
use WxMOO::Window::MainSplitter;
use WxMOO::Window::InputPane;
use WxMOO::Window::OutputPane;
use WxMOO::Window::PrefsEditor;
use WxMOO::Window::ConnectDialog;
use WxMOO::Prefs;
use WxMOO::Utility qw(id);

use base 'Wx::Frame';

method new($class:) {
    my $self = $class->SUPER::new( undef, -1, 'WxMOO' );

    $self->buildMenu;

    # TODO - don't connect until we ask for it.
    $self->{'connection'} = WxMOO::Connection->new($self);

    my $Splitter = WxMOO::Window::MainSplitter->new($self);

    my $OutputPane = WxMOO::Window::OutputPane->new($Splitter);
    my $InputPane  = WxMOO::Window::InputPane ->new($Splitter, $self->{'connection'});

    $Splitter->SplitHorizontally($OutputPane, $InputPane);
    $Splitter->SetMinimumPaneSize(20); # TODO - set to "one line of input field"

    my $Sizer = Wx::BoxSizer->new( wxVERTICAL );
    $Sizer->Add($Splitter, 1, wxALL|wxGROW, 5);
    $self->SetSizer($Sizer);

    return $self;
}

# post ->Show stuff
method Initialize {
    # TODO - don't connect until we ask for it.
    $self->{'connection'}->connect;
}

method showPrefsEditor {
    $self->{'prefsEditor'} ||= WxMOO::Window::PrefsEditor->new($self);
    $self->{'prefsEditor'}->Show;
}

method showConnectDialog {
    $self->{'connectDialog'} ||= WxMOO::Window::ConnectDialog->new($self);
    $self->{'connectDialog'}->Show;
}

method showAboutBox { Wx::AboutBox("It's about this long, and about this wide.") }

method quitApplication {
    WxMOO::Prefs->instance->save;
    $self->Close(1);
}

method buildMenu {
    my $WorldsMenu = Wx::Menu->new;
    $WorldsMenu->Append(id('MENUITEM_WORLDS'),  "Worlds...",        "");
    $WorldsMenu->Append(id('MENUITEM_CONNECT'), "Connect...",       "");
    $WorldsMenu->Append(id('MENUITEM_CLOSE'),   "Close",            "");
    $WorldsMenu->AppendSeparator;
    $WorldsMenu->Append(id('MENUITEM_QUIT'),    "Quit",             "");

    my $EditMenu = Wx::Menu->new;
    $EditMenu->Append(id('MENUITEM_CUT'),       "Cut",              "");
    $EditMenu->Append(id('MENUITEM_COPY'),      "Copy",             "");
    $EditMenu->Append(id('MENUITEM_PASTE'),     "Paste",            "");
    $EditMenu->Append(id('MENUITEM_CLEAR'),     "Clear",            "");

    my $PrefsMenu = Wx::Menu->new;
    $PrefsMenu->Append(id('MENUITEM_PREFS'),    "Edit Preferences", "");

    my $HelpMenu = Wx::Menu->new;
    $HelpMenu->Append(id('MENUITEM_HELP'),      "Help Topics",      "");
    $HelpMenu->Append(id('MENUITEM_ABOUT'),     "About WxMOO",      "");

    my $MenuBar = Wx::MenuBar->new;
    $MenuBar->Append($WorldsMenu, "Worlds");
    $MenuBar->Append($EditMenu, "Edit");
    $MenuBar->Append($PrefsMenu, "Preferences");
    $MenuBar->Append($HelpMenu, "Help");

    $self->SetMenuBar($MenuBar);

    # MENUBAR EVENTS
    EVT_MENU( $self, id('MENUITEM_WORLDS'),  sub {1} );
    EVT_MENU( $self, id('MENUITEM_CONNECT'), \&showConnectDialog );
    EVT_MENU( $self, id('MENUITEM_CLOSE'),   sub {1} );
    EVT_MENU( $self, id('MENUITEM_QUIT'),    \&quitApplication );

    EVT_MENU( $self, id('MENUITEM_CUT'),     sub {1} );
    EVT_MENU( $self, id('MENUITEM_COPY'),    sub {1} );
    EVT_MENU( $self, id('MENUITEM_PASTE'),   sub {1} );
    EVT_MENU( $self, id('MENUITEM_CLEAR'),   sub {1} );

    EVT_MENU( $self, id('MENUITEM_PREFS'),   \&showPrefsEditor );

    EVT_MENU( $self, id('MENUITEM_HELP'),    sub {1} );
    EVT_MENU( $self, id('MENUITEM_ABOUT'),   \&showAboutBox );
}
