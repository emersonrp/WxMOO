package WxMOO::MCP21::Package::dns_org_mud_moo_simpleedit;
use strict;
use warnings;
use v5.14;

use Carp;
use Method::Signatures;
no if $] >= 5.018, warnings => "experimental::smartmatch";

# this code is already in dire need of a rework, but it's starting work at all, at least.

use File::Temp;
use File::Slurp 'slurp';
use Wx qw( :id :execute );
use Wx::Event qw( EVT_END_PROCESS EVT_TIMER );

use parent 'WxMOO::MCP21::Package';

# TODO - this'll be a preference
use constant EDITOR => '/usr/bin/gvim';

method new($class:) {
    my $self = $class->SUPER::new({
        package => 'dns-org-mud-moo-simpleedit',
        min     => '1.0',
        max     => '1.0',
    });

    $WxMOO::MCP21::registry->register($self, qw( dns-org-mud-moo-simpleedit-content ));
    $self->_init;
}

method _init {
    $self->{'watched'} = {};
    $self->{'watchTimer'} = Wx::Timer->new($self, -1);
    EVT_TIMER($self, $self->{'watchTimer'}, \&_watch_queue);

}
method dispatch($message) {
    given ($message->{'message'}) {
        when ('dns-org-mud-moo-simpleedit-content') {
            $self->dns_org_mud_moo_simpleedit_content($message);
        }
    }
}

method dns_org_mud_moo_simpleedit_content($mcp_msg) {

    my $tempfile = $self->_make_tempfile($mcp_msg);

    my $process = Wx::Process->new;
    $process->{'_file'} = $tempfile;
    Wx::ExecuteCommand(EDITOR . " -f $tempfile", wxEXEC_NODISABLE, $process );

    $self->{'msgs_in_progress'}->{$tempfile} = $mcp_msg;

    $self->_start_watching($tempfile);

    # This is sorta hinky - have to do these sub{} gyrations to get $self right.
    EVT_END_PROCESS( $process, wxID_ANY, sub { $self->_send_and_cleanup(@_) } );
}


method _send_and_cleanup($proc, $evt) {
    my $file = $proc->{'_file'};
    $self->_send_file_if_needed($file);
    $self->_stop_watching($file);
    delete $self->{'msgs_in_progress'}->{$file};
    unlink $file;
}

# our queue of known tempfiles with editors sitting open.
# we want "save" to send the data to the MOO, so we'll
# stat() the queue every once in a while.
method _start_watching($file) {
    $self->{'watched'}->{$file} = (stat $file)[9];
    unless ($self->{'watchTimer'}->IsRunning) {
        $self->{'watchTimer'}->Start(250, 0);
    }
}

method _stop_watching($file) {
    delete $self->{'watched'}->{$file};
    unless (keys %{$self->{'watched'}}) {
        $self->{'watchTimer'}->Stop;
    }
}

method _watch_queue {
    for my $file (keys %{$self->{'watched'}}) {
        $self->_send_file_if_needed($file);
    }
}

method _send_file_if_needed($file) {
    my $mtime = (stat $file)[9] or carp "wtf is wrong with $file?!?";
    if ($mtime > $self->{'watched'}->{$file}) {
        # shipit!
        my $mcp_msg = $self->{'msgs_in_progress'}->{$file};
        my @content = slurp($file) or return;
        WxMOO::MCP21::server_notify(
            'dns-org-mud-moo-simpleedit-set', {
                reference => $mcp_msg->{'data'}->{'reference'},
                type      => $mcp_msg->{'data'}->{'type'},
                content   => \@content,
            }
        );
        $self->{'watched'}->{$file} = $mtime;
    }
}

method _make_tempfile($mcp_msg) {

    # if it's moocode, give it an extension so vim et al will syntax-highlight
    my $extension = $mcp_msg->{'data'}->{'type'} eq 'moo-code' ? '.moo' : '.tmp';

    my $tempfile = File::Temp->new(
        TEMPLATE => 'wxmoo_XXXXX',
        SUFFIX   => $extension,
        DIR      => '/tmp',  # TODO - cross-platform pls
    );

    for (@{$mcp_msg->{'data'}->{'content'}}) {
        s///; # ok ew - there's got to be some deterministic way to dtrt here.
        say $tempfile $_;
    }
    $tempfile->flush;

    return $tempfile;
}

1;
