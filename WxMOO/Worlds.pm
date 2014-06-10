# This is a class that wraps Wx::Prefs for simpler access to
# the worlds list and individual worlds
package WxMOO::Worlds;
use strict;
use warnings;
use v5.14;

use Carp;
use WxMOO::Prefs;
use base qw( Class::Accessor );
WxMOO::Worlds->mk_accessors(qw( config ));

sub init {
    my ($class) = @_;
    state $self;

    unless ($self) {
        $self = {
            'config' => WxMOO::Prefs->prefs->config,
        };
        bless $self, $class;
    };
    $self->load_worlds;
    return $self;
}

sub load_worlds {
    my ($self) = @_;

    my $config = $self->{'config'};

    $config->SetPath('/worlds');
    my $worlds = {};

    if (my $groupcount = $config->GetNumberOfGroups) {
        for my $i (1 .. $groupcount) {
            my (undef, $worldname, undef) = $config->GetNextGroup($i-1);
            $config->SetPath($worldname);
            my $worlddata = {};
            if (my $datacount = $config->GetNumberOfEntries) {
                for my $j (1 .. $datacount) {
                    my (undef, $dataname, undef) = $config->GetNextEntry($j-1);
                    $worlddata->{$dataname} = $config->Read($dataname);
                }
                $worlds->{$worldname} = WxMOO::World->new($worlddata);
            }
            $config->SetPath('/worlds');
        }
    } else {
        # populate the worlds with the default list, and save it.
        say STDERR "populating empty list";
        my $worlds = initial_worlds();
        while (my ($worldname, $data) = each %$worlds) {
            $worlds->{$worldname} = WxMOO::World->new($data);
            $config->SetPath($worldname);
            while (my ($k, $v) = each %$data) {
                $config->Write($k, $v);
            }
            $config->SetPath('/worlds');
        }
    }
    return $worlds;
}

sub worlds {
    my $self = shift;
    $self->{'worlds'} //= $self->load_worlds;
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
use Class::Accessor;

use base qw( Class::Accessor );

my @fields = qw(
    name host port user pass note type
    ssh_server ssh_user ssh_loc_host ssh_loc_port
    ssh_rem_host ssh_rem_port
);
WxMOO::World->mk_accessors(@fields);

my %defaults = (
    port       => 7777,
    type       => 0,   # Socket
);

sub new {
    my ($class, $init) = @_;
    unless (%$init) { $init = \%defaults; }
    bless $init, $class;

}

sub save {
    my $self = shift;
    my $config = $self->config;

    (my $keyname = $self->name) =~ s/\W/_/g;
    $config->SetPath("/worlds/$keyname");
    for my $f (@fields) {
        $config->Write($f, $self->{$f});
    }
    return $self;
}

sub create {
    my $self = shift;
    my $newworld = $self->new;
    $newworld->save;
}

1;
