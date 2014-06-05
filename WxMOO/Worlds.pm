# This is a class that wraps Wx::Prefs for simpler access to
# the worlds list and individual worlds
package WxMOO::Worlds;
use strict;
use warnings;
use v5.14;

use Carp;
use Wx qw( :font :colour );

sub init {
    my ($class) = @_;
    state $self;

    unless ($self) {
        $self = {
            'config' => WxMOO::Prefs->prefs->config,
            'worlds' => {},
        };
        bless $self, $class;
    };
    $self->worlds;
    return $self;
}

sub worlds {
    my ($self) = @_;

    my $config = $self->{'config'};

    $config->SetPath('/worlds');

    if (my $groupcount = $config->GetNumberOfGroups) {
        for my $k (1 .. $groupcount) {
            my (undef, $world, undef) = $config->GetNextGroup($k-1);
            $config->SetPath($world);
# TODO - for each entry in this group, populate $self->{'worlds'}
            $config->SetPath('/worlds');
        }
    } else {
        # populate the worlds with the default list, and save it.
        say STDERR "populating empty list";
        my $worlds = initial_worlds();
        while (my ($world, $data) = each %$worlds) {
            $self->{'worlds'}->{$world} = $data;
            $config->SetPath($world);
            while (my ($k, $v) = each %$data) {
                $config->Write($k, $v);
            }
            $config->SetPath('/worlds');
        }
    }
    return $self->{'worlds'};
}

### Massager-accessors; transform from config-file strings to useful data

### DEFAULTS -- this will set everything to a default value if it's not already set.
#               This gives us both brand-new-file and add-new-params'-default-values

sub initial_worlds {
    {
        'lambdamoo' => {
            'name' => "Lambdamoo",
            'host' => "lambda.moo.mud.org",
            'port' => 8888,
            'type' => 0,
        },
        'the_meadow' => {
            'name' => "The Meadow",
            'host' => "moo.hayseed.net",
            'port' => 7777,
            'type' => 0,
        },
    }
}

#####################
package WxMOO::World;
use strict;
use warnings;
use v5.14;

sub new {
}

use constant SIMPLE_ACCESSORS => qw(
    name host port username password type
    ssh_server ssh_username local_port
);


{
    my %defaults = (
        port       => 7777,
        type       => 0,   # Socket
        local_port => 7777,
    );

    sub get_defaults {
        my ($self) = @_;
        while (my ($key,$val) = each %defaults) {
            $self->param($key, $val) unless defined $self->param($key);
        }
    }
}

# make automagic accessors
for my $accname (SIMPLE_ACCESSORS) {
    my $code = sub {
        my $self = shift;
        $self->param($accname, @_) if @_;
        return $self->param($accname);
    };

    no strict 'refs';
    *$accname = $code;
}


1;
