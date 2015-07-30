package WxMOO::Window::Main;
use strict;
use warnings;
use v5.14;

use Wx qw( :id :frame :misc :sizer );
use Wx::Event qw( EVT_MENU EVT_SIZE );

use WxMOO::Connection;  # Might go away later
use WxMOO::Prefs;
use WxMOO::Editor;

use WxMOO::Window::ConnectDialog;
use WxMOO::Window::DebugMCP;
use WxMOO::Window::MainSplitter;
use WxMOO::Window::Main::InputPane;
use WxMOO::Window::Main::OutputPane;
use WxMOO::Window::PrefsEditor;
use WxMOO::Window::WorldsList;

use base qw( Wx::Frame Class::Accessor );
WxMOO::Window::Main->mk_accessors(qw( connection input_pane output_pane status_bar ));

my $prefs = WxMOO::Prefs->prefs;

sub new {
    my ($class) = @_;
    my $self = $class->SUPER::new( undef, -1, 'WxMOO',
        wxDefaultPosition, wxDefaultSize,
        wxDEFAULT_FRAME_STYLE);

    # TODO - status bar is so biig but it would be nice to have it.
    # $self->status_bar($self->CreateStatusBar);

    $self->buildMenu;

    $self->addEvents;

    my $h = 600;  my $w = 800;
    if ( $prefs->save_window_size) {
        $w = $prefs->window_width  if $prefs->window_width;
        $h = $prefs->window_height if $prefs->window_height;
    }
    $self->SetSize([$w, $h]);

    my $splitter = WxMOO::Window::MainSplitter->new($self);

    $self->input_pane (WxMOO::Window::Main::InputPane ->new($splitter));
    $self->output_pane(WxMOO::Window::Main::OutputPane->new($splitter));

    $splitter->SplitHorizontally($self->output_pane, $self->input_pane);
    $splitter->SetMinimumPaneSize(20); # TODO - set to "one line of input field"

    my $sizer = Wx::BoxSizer->new( wxVERTICAL );
    $sizer->Add($splitter, 1, wxALL|wxGROW);
    $self->SetSizer($sizer);

    # TODO - don't connect until we ask for it.
    # TODO - probably want a tabbed interface for multiple connections
    $self->connection(WxMOO::Connection->new($self));

    return $self;
}

# post ->Show stuff
sub Initialize {
    my ($self) = @_;
    # TODO - don't connect until we ask for it.
    $self->connection->connect('hayseed.net',7777);
}

sub buildMenu {
    my ($self) = @_;
    my $WorldsMenu = Wx::Menu->new;
    my $W_worlds  = $WorldsMenu->Append(-1, "&Worlds...",  "Browse list of worlds");
    my $W_connect = $WorldsMenu->Append(-1, "&Connect...", "Connect to a host and port");
    $WorldsMenu->Append(wxID_CLOSE, '');
    $WorldsMenu->AppendSeparator;
    my $W_reconnect = $WorldsMenu->Append(-1, "&Reconnect", "Close and re-open the current connection");
    $WorldsMenu->Append(wxID_EXIT, '');

    my $EditMenu = Wx::Menu->new;
    $EditMenu->Append(wxID_CUT,   '');
    $EditMenu->Append(wxID_COPY,  '');
    $EditMenu->Append(wxID_PASTE, '');

    my $PrefsMenu = Wx::Menu->new;
    $PrefsMenu->Append(wxID_PREFERENCES, "&Preferences\tCTRL-P");

    my $WindowMenu = Wx::Menu->new;
    my $Window_debugmcp = $WindowMenu->Append(-1, "&Debug MCP", "");

    my $HelpMenu = Wx::Menu->new;
    $HelpMenu->Append(wxID_HELP,  '' , "&Help Topics" );
    $HelpMenu->Append(wxID_ABOUT, '');

    my $MenuBar = Wx::MenuBar->new;
    $MenuBar->Append($WorldsMenu, "&Worlds");
    $MenuBar->Append($EditMenu,   "&Edit");
    $MenuBar->Append($PrefsMenu,  "&Preferences");
    $MenuBar->Append($WindowMenu, "W&indows");
    $MenuBar->Append($HelpMenu,   "&Help");

    $self->SetMenuBar($MenuBar);

    # MENUBAR EVENTS
    EVT_MENU( $self, $W_worlds,    \&showWorldsList      );
    EVT_MENU( $self, $W_connect,   \&showConnectDialog   );
    EVT_MENU( $self, wxID_CLOSE,   \&closeConnection     );
    EVT_MENU( $self, $W_reconnect, \&reconnectConnection );
    EVT_MENU( $self, wxID_EXIT,    \&quitApplication     );

    EVT_MENU( $self, wxID_CUT,     \&handleCut   );
    EVT_MENU( $self, wxID_COPY,    \&handleCopy  );
    EVT_MENU( $self, wxID_PASTE,   \&handlePaste );

    EVT_MENU( $self, wxID_PREFERENCES, \&showPrefsEditor );

    EVT_MENU( $self, $Window_debugmcp, \&showDebugMCP );

    EVT_MENU( $self, wxID_HELP,  sub {1} );
    EVT_MENU( $self, wxID_ABOUT, \&showAboutBox );
}

sub addEvents {
    my ($self) = @_;

    EVT_SIZE( $self, \&onSize );
}

sub closeConnection {
    my ($self) = @_;
    $self->connection->Close;
}

sub reconnectConnection {
    my ($self) = shift;
    $self->connection->reconnect;
}

sub onSize {
    my ($self, $evt) = @_;

    if ($prefs->save_window_size) {
        my ($w, $h) = $self->GetSizeWH;
        $prefs->window_width($w);
        $prefs->window_height($h);
    }
    $evt->Skip;
}

sub handleCopy  {
    my ($self) = @_;
    if    ($self->output_pane->HasSelection) { $self->output_pane->Copy }
    elsif ($self->input_pane ->HasSelection) { $self->input_pane ->Copy }
}
sub handleCut   { shift->input_pane->Cut }
sub handlePaste { shift->input_pane->Paste }

### DIALOGS AND SUBWINDOWS

sub showWorldsList {
    my ($self) = @_;
    $self->{'worlds_list'} ||= WxMOO::Window::WorldsList->new($self);
    $self->{'worlds_list'}->Show;
}

sub showConnectDialog {
    my ($self) = @_;
    $self->{'connect_dialog'} ||= WxMOO::Window::ConnectDialog->new($self);
    $self->{'connect_dialog'}->Show;
}

sub showPrefsEditor {
    my ($self) = @_;
    $self->{'prefs_editor'} ||= WxMOO::Window::PrefsEditor->new($self);
    $self->{'prefs_editor'}->Show;
}

sub showDebugMCP {
    my ($self) = @_;
    $self->{'debug_mcp'} ||= WxMOO::Window::DebugMCP->new($self);
    $self->{'debug_mcp'}->toggle_visible;
}

# TODO - WxMOO::Window::About
sub showAboutBox {
    my ($self) = @_;
    $self->{'about_info'} ||= eval {
        my $info = Wx::AboutDialogInfo->new;
        $info->AddDeveloper('R Pickett (emerson@hayseed.net)');
        $info->SetCopyright('(c) 2013, 2014, 2015');
        $info->SetWebSite('http://github.com/emersonrp/WxMOO');
        $info->SetName('WxMOO');
        $info->SetVersion('0.0.1');
        return $info;
    };

    Wx::AboutBox($self->{'about_info'});
}



sub quitApplication {
    my ($self) = @_;
    $self->closeConnection;
    $self->Close(1);
}

1;
