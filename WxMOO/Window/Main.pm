package WxMOO::Window::Main;
use perl5i::2;

use Wx qw( :misc :sizer );
use Wx::Event qw( EVT_MENU );

use WxMOO::Connection;  # Might go away later
use WxMOO::Prefs;
use WxMOO::Utility qw(id);

use WxMOO::Window::ConnectDialog;
use WxMOO::Window::InputPane;
use WxMOO::Window::MainSplitter;
use WxMOO::Window::OutputPane;
use WxMOO::Window::PrefsEditor;
use WxMOO::Window::WorldsList;

use base 'Wx::Frame';

method new($class:) {
    my $self = $class->SUPER::new( undef, -1, 'WxMOO' );

    $self->buildMenu;

    # TODO - don't connect until we ask for it.
    $self->{'connection'} = WxMOO::Connection->new($self);

    $self->{'splitter'} = WxMOO::Window::MainSplitter->new($self);

    $self->{'input_pane'}  = WxMOO::Window::InputPane ->new($self->{'splitter'}, $self->{'connection'});
    $self->{'output_pane'} = WxMOO::Window::OutputPane->new($self->{'splitter'});

    $self->{'splitter'}->SplitHorizontally($self->{'output_pane'}, $self->{'input_pane'});
    $self->{'splitter'}->SetMinimumPaneSize(20); # TODO - set to "one line of input field"

    $self->{'sizer'} = Wx::BoxSizer->new( wxVERTICAL );
    $self->{'sizer'}->Add($self->{'splitter'}, 1, wxALL|wxGROW, 5);
    $self->SetSizer($self->{'sizer'});

    return $self;
}

# post ->Show stuff
method Initialize {
    # TODO - don't connect until we ask for it.
    $self->{'connection'}->connect('hayseed.net',7777);
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
    EVT_MENU( $self, id('MENUITEM_WORLDS'),  \&showWorldsList    );
    EVT_MENU( $self, id('MENUITEM_CONNECT'), \&showConnectDialog );
    EVT_MENU( $self, id('MENUITEM_CLOSE'),   \&closeConnection   );
    EVT_MENU( $self, id('MENUITEM_QUIT'),    \&quitApplication   );

    EVT_MENU( $self, id('MENUITEM_CUT'),     sub {1} );
    EVT_MENU( $self, id('MENUITEM_COPY'),    sub {1} );
    EVT_MENU( $self, id('MENUITEM_PASTE'),   sub {1} );
    EVT_MENU( $self, id('MENUITEM_CLEAR'),   sub {1} );

    EVT_MENU( $self, id('MENUITEM_PREFS'),   \&showPrefsEditor );

    EVT_MENU( $self, id('MENUITEM_HELP'),    sub {1} );
    EVT_MENU( $self, id('MENUITEM_ABOUT'),   \&showAboutBox );
}

method closeConnection {
    $self->{'connection'}->Destroy;
    $self->{'connection'} = undef;
}

### DIALOGS AND SUBWINDOWS

method showWorldsList {
    $self->{'worlds_list'} ||= WxMOO::Window::WorldsList->new($self);
    $self->{'worlds_list'}->Show;
}

method showConnectDialog {
    $self->{'connect_dialog'} ||= WxMOO::Window::ConnectDialog->new($self);
    $self->{'connect_dialog'}->Show;
}

method showPrefsEditor {
    $self->{'prefs_editor'} ||= WxMOO::Window::PrefsEditor->new($self);
    $self->{'prefs_editor'}->Show;
}

# TODO - WxMOO::Window::About
method showAboutBox {
    $self->{'about_info'} ||= eval {
        my $info = Wx::AboutDialogInfo->new;
        $info->AddDeveloper('R Pickett (emerson@hayseed.net)');
        $info->SetCopyright('(c) 2013');
        $info->SetName('WxMOO');
        $info->SetVersion('0.0.1');
        return $info;
    };

    Wx::AboutBox($self->{'about_info'});
}

method quitApplication {
    WxMOO::Prefs->prefs->save;
    $self->closeConnection;
    $self->Close(1);
}
