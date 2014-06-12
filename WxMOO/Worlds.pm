# This is a class that wraps Wx::Prefs for simpler access to
# the worlds list and individual worlds
package WxMOO::Worlds;
use strict;
use warnings;
use v5.14;

use Carp;
use File::Slurp 'read_file';
use JSON;
use WxMOO::Prefs;
use base qw( Class::Accessor );
WxMOO::Worlds->mk_accessors(qw( config ));

sub init {
    my ($class) = @_;
    state $self;

    unless ($self) {
        $self = {
            'prefs' => WxMOO::Prefs->prefs,
        };
        bless $self, $class;
    };
    return $self;
}

sub load_worlds {
    my ($self) = @_;

    my $prefs = $self->{'prefs'};

    $prefs->config->SetPath('/worlds');
    my $worlds = [];

    if (my $groupcount = $prefs->config->GetNumberOfGroups) {
        for my $i (1 .. $groupcount) {
            my (undef, $worldname, undef) = $prefs->config->GetNextGroup($i-1);
            $prefs->config->SetPath($worldname);
            my $worlddata = {};
            if (my $datacount = $prefs->config->GetNumberOfEntries) {
                for my $j (1 .. $datacount) {
                    my (undef, $dataname, undef) = $prefs->config->GetNextEntry($j-1);
                    $worlddata->{$dataname} = $prefs->config->Read($dataname);
                }
                push @$worlds, WxMOO::World->new($worlddata);
            }
            $prefs->config->SetPath('/worlds');
        }
    } else {
        # populate the worlds with the default list, and save it.
        say STDERR "populating empty list";
        my $init_worlds = initial_worlds();
        for my $data (@$init_worlds) {
            push @$worlds, WxMOO::World->new($data);
            $prefs->config->SetPath($data->{'name'});
            while (my ($k, $v) = each %$data) {
                $prefs->Write($k, $v);
            }
            $prefs->config->SetPath('/worlds');
        }
    }
    return $worlds;
}

sub worlds {
    my $self = shift;
    $self->{'worlds'} //= $self->load_worlds;
}

sub initial_worlds {
    return decode_json do { local $/; <WxMOO::World::DATA> };
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

### DEFAULTS -- this will set everything to a default value if it's not already set.
#               This gives us both brand-new-file and add-new-params'-default-values
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
    my $prefs = WxMOO::Prefs->prefs;

    (my $keyname = $self->name) =~ s/\W/_/g;
    $prefs->config->SetPath("/worlds/$keyname");
    for my $f (@fields) {
        $prefs->Write($f, $self->{$f});
    }
    return $self;
}

sub create {
    my $self = shift;
    my $newworld = $self->new;
    $newworld->save;
}

1;

__DATA__

[
    {
        "name"  :  "AnsibleMOO",
        "url"   :  "http://ansiblemoo.org/",
        "host"  :  "ansiblemoo.org",
        "port"  :  6000
    },
    {
        "name"  :  "Arthnor",
        "host"  :  "q.geek.nz",
        "port"  :  8888
    },
    {
        "name"  :  "ASI MOO",
        "url"   :  "http://www.asi.org/adb/09/08/04/moo.html",
        "host"  :  "moo.asi.org",
        "port"  :  7777
    },
    {
        "name"  :  "BrightMOO",
        "url"   :  "http://brightmoo.genesismuds.com",
        "host"  :  "brightmoo.genesismuds.com",
        "port"  :  7760
    },
    {
        "name"  :  "CyberMedia Culture",
        "url"   :  "http://cmc.ub.no:8000",
        "host"  :  "cmc.uib.no",
        "port"  :  8888
    },
    {
        "name"  :  "De Digitale Metro",
        "url"   :  "http://demetro.nl/",
        "host"  :  "demetro.nl",
        "port"  :  8888
    },
    {
        "name"  :  "DownMOO",
        "host"  :  "downmoo.sloth.org",
        "port"  :  8888
    },
    {
        "name"  :  "Dreistadt",
        "url"   :  "http://cmc.uib.no/dreistadt",
        "host"  :  "cmc.uib.no",
        "port"  :  7777
    },
    {
        "name"  :  "DuneMOO",
        "url"   :  "http://www.dunemoo.com",
        "host"  :  "moo.dunemoo.com",
        "port"  :  9800
    },
    {
        "name"  :  "FooMOO",
        "url"   :  "http://www.foomoo.org/",
        "host"  :  "foomoo.org",
        "port"  :  4500
    },
    {
        "name"  :  "Fractured",
        "url"   :  "http://fracturedproject.net/",
        "host"  :  "fracturedproject.net",
        "port"  :  5139
    },
    {
        "name"  :  "Ghostwheel",
        "url"   :  "http://fazigu.org/~quinn/ghost/",
        "host"  :  "moo.ghostmoo.org",
        "port"  :  6969
    },
    {
        "name"  :  "Ghostwheel Redux",
        "url"   :  "http://ghostredux.wikispaces.com/",
        "host"  :  "esque.com",
        "port"  :  6969
    },
    {
        "name"  :  "Harper's Tale",
        "url"   :  "http://www.harpers-tale.com/",
        "host"  :  "moo.harpers-tale.com",
        "port"  :  7007
    },
    {
        "name"  :  "Hell: After the End",
        "url"   :  "http://aftertheend.org",
        "host"  :  "aftertheend.org",
        "port"  :  7777
    },
    {
        "name"  :  "HellMOO",
        "url"   :  "http://hellmoo.org",
        "host"  :  "hellmoo.org",
        "port"  :  7777
    },
    {
        "name"  :  "HellYeah",
        "url"   :  "http://www.hellyeah.com/moo/",
        "host"  :  "moo.hellyeah.com",
        "port"  :  7777
    },
    {
        "name"  :  "Holotrek",
        "url"   :  "http://www.holotrek.org/",
        "host"  :  "holotrek.org",
        "port"  :  1701
    },
    {
        "name"  :  "InfernoMOO",
        "host"  :  "inferno.optiquest.org",
        "port"  :  7777
    },
    {
        "name"  :  "LambdaMOO",
        "url"   :  "http://www.moo.mud.org/",
        "host"  :  "lambda.moo.mud.org",
        "port"  :  8888
    },
    {
        "name"  :  "LostAges",
        "url"   :  "http://skeetre.com:6970",
        "host"  :  "mudz.org",
        "port"  :  6969
    },
    {
        "name"  :  "MarsHome",
        "url"   :  "http://moo.marshome.org/",
        "host"  :  "moo.marshome.org",
        "port"  :  7777
    },
    {
        "name"  :  "Mast Effect: Alpha & Omega",
        "url"   :  "http://me-alphaomega.com/wiki/",
        "host"  :  "me-alphaomega.com",
        "port"  :  7007
    },
    {
        "name"  :  "MediaMOO",
        "url"   :  "http://www.cc.gatech.edu/fac/Amy.Bruckman/MediaMOO/",
        "host"  :  "mediamoo.engl.niu.edu",
        "port"  :  8888
    },
    {
        "name"  :  "Medieval",
        "url"   :  "http://www.medievalmoo.nl/",
        "host"  :  "moo.medievalmoo.nl",
        "port"  :  1111
    },
    {
        "name"  :  "MidgardMOO",
        "url"   :  "http://moo.midgard.org",
        "host"  :  "moo.midgard.org",
        "port"  :  1359
    },
    {
        "name"  :  "Miriani",
        "url"   :  "http://www.toastsoft.net/",
        "host"  :  "toastsoft.net",
        "port"  :  1234
    },
    {
        "name"  :  "MOO Canada, Eh?",
        "url"   :  "http://www.moo.ca/",
        "host"  :  "moo.ca",
        "port"  :  7777
    },
    {
        "name"  :  "MOOMellow",
        "url"   :  "http://www.chilipepper.com:7000/",
        "host"  :  "moo.chilipepper.com",
        "port"  :  7777
    },
    {
        "name"  :  "MOOsaico",
        "url"   :  "http://moosaico.com",
        "host"  :  "moo.di.uminho.pt",
        "port"  :  7777
    },
    {
        "name"  :  "MooYeah!",
        "host"  :  "moo.hellyeah.com",
        "port"  :  7777
    },
    {
        "name"  :  "Once Upon A MOO",
        "url"   :  "http://rupert.twyst.org:7778",
        "host"  :  "rupert.twyst.org",
        "port"  :  7777
    },
    {
        "name"  :  "OpalMOO",
        "host"  :  "moo.opal.org",
        "port"  :  7878
    },
    {
        "name"  :  "Port of Dreams",
        "url"   :  "http://phaze.ca/pod/",
        "host"  :  "phaze.ca",
        "port"  :  9999
    },
    {
        "name"  :  "ProgrammingLand MOO",
        "url"   :  "http://http://euler.vcsu.edu/pland.htm",
        "host"  :  "euler.vcsu.edu",
        "port"  :  7777
    },
    {
        "name"  :  "Pyramid",
        "url"   :  "http://www.sjgames.com/pyramid/chat.html",
        "host"  :  "pyramid.sjgames.com",
        "port"  :  2323
    },
    {
        "name"  :  "Rupert",
        "url"   :  "http://rupert.twyst.org/",
        "host"  :  "rupert.twyst.org",
        "port"  :  9040
    },
    {
        "name"  :  "Ryksyll MOO",
        "url"   :  "http://moo.ryksyll.com:8889/",
        "host"  :  "moo.ryksyll.com",
        "port"  :  8888
    },
    {
        "name"  :  "SchMOOzeU",
        "url"   :  "http://schmooze.hunter.cuny.edu:8888",
        "host"  :  "schmooze.hunter.cuny.edu",
        "port"  :  8888
    },
    {
        "name"  :  "ScienceMOO",
        "url"   :  "http://www.sciencemoo.org:7000",
        "host"  :  "sciencemoo.org",
        "port"  :  7777
    },
    {
        "name"  :  "Sindome",
        "url"   :  "http://sindome.org",
        "host"  :  "moo.sindome.org",
        "port"  :  5555
    },
    {
        "name"  :  "Star Conquest",
        "url"   :  "http://www.squidsoft.com/",
        "host"  :  "squidsoft.net",
        "port"  :  7777
    },
    {
        "name"  :  "TECFA",
        "url"   :  "http://tecfa.unige.ch/tecfamoo.html",
        "host"  :  "tecfamoo.unige.ch",
        "port"  :  7777
    },
    {
        "name"  :  "TerraMOO",
        "url"   :  "http://moo.terrace.qld.edu.au:8000/",
        "host"  :  "moo.terrace.qld.edu.au",
        "port"  :  7000
    },
    {
        "name"  :  "The Ethereal Kingdom",
        "url"   :  "http://www.virtadpt.net/",
        "host"  :  "keep.quarteredcircle.net",
        "port"  :  2305
    },
    {
        "name"  :  "The Meadow",
        "url"   :  "http://www.hayseed.net/meadow.html",
        "host"  :  "hayseed.net",
        "port"  :  7777
    },
    {
        "name"  :  "the-night.com",
        "url"   :  "http://www.the-night.com/",
        "host"  :  "the-night.com",
        "port"  :  2000
    },
    {
        "name"  :  "TrekMOO VI",
        "host"  :  "virtualworlds.peidev.com",
        "port"  :  9529
    },
    {
        "name"  :  "Utopia",
        "url"   :  "http://www.utopiamoo.net/",
        "host"  :  "utopiamoo.net",
        "port"  :  1111
    },
    {
        "name"  :  "Vast Space",
        "host"  :  "87.117.247.136",
        "port"  :  1234
    },
    {
        "name"  :  "VRoma",
        "url"   :  "http://www.vroma.org/",
        "host"  :  "vroma.org",
        "port"  :  8200
    },
    {
        "name"  :  "Wacky MOO",
        "url"   :  "http://wackymoo.jellybean.co.uk:8081/",
        "host"  :  "wackymoo.jellybean.co.uk",
        "port"  :  7777
    },
    {
        "name"  :  "Waterpoint",
        "url"   :  "http://waterpoint.moo.mud.org/",
        "host"  :  "waterpoint.moo.mud.org",
        "port"  :  8301
    },
    {
        "name"  :  "Wayfar 1444",
        "url"   :  "http://www.wayfar1444.com",
        "host"  :  "wayfar1444.com",
        "port"  :  7777
    },
    {
        "name"  :  "Where No One Has Gone Before",
        "url"   :  "http://www.wnohgb.org/",
        "host"  :  "game.wnohgb.org",
        "port"  :  1701
    },
    {
        "name"  :  "YibMOO",
        "host"  :  "yibmoo.dyndns.org",
        "port"  :  7777
    }
]
