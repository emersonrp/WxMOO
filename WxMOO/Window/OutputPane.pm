package WxMOO::Window::OutputPane;
use strict;
use warnings;
use v5.14;

no if $] >= 5.018, warnings => "experimental::smartmatch";

use Wx qw( :color :misc :textctrl );
use Wx::RichText;
use Wx::Event qw( EVT_SET_FOCUS EVT_TEXT_URL );

use WxMOO::Prefs;
use WxMOO::Utility qw( URL_REGEX );

# TODO we need a better output_filter scheme, probably?
use WxMOO::MCP21;

use base qw( Wx::RichTextCtrl Class::Accessor );
WxMOO::Window::OutputPane->mk_accessors(qw( input_pane ));

sub new {
    my ($class, $parent) = @_;
    my $self = $class->SUPER::new(
        $parent, -1, "", wxDefaultPosition, wxDefaultSize,
            wxTE_AUTO_URL | wxTE_READONLY | wxTE_NOHIDESEL
        );

    $self->input_pane($parent->{'input_pane'});

    $self->restyle_thyself;

    EVT_SET_FOCUS($self,       \&focus_input);
    EVT_TEXT_URL($self, $self, \&process_url_click);

    return bless $self, $class;
}

sub process_url_click {
    my ($self, $event) = @_;
    my $url = $event->GetString;
    # TODO - make this whole notion into a platform-agnostic launchy bit;
    system('xdg-open', $url);
}

sub WriteText {
    my ($self, @rest) = @_;
    $self->SUPER::WriteText(@rest);
    $self->ScrollIfAppropriate;
}

sub ScrollIfAppropriate {
    my ($self) = @_;
    # TODO:  "if we want scroll-on-output or are already at the bottom..."
    $self->ShowPosition($self->GetCaretPosition);
}

sub restyle_thyself {
    my ($self) = @_;
    my $basic_style = Wx::RichTextAttr->new;
    $basic_style->SetTextColour      (WxMOO::Prefs->prefs->output_fgcolour);
    $basic_style->SetBackgroundColour(WxMOO::Prefs->prefs->output_bgcolour);
    $self->SetBackgroundColour(WxMOO::Prefs->prefs->output_bgcolour);
    $self->SetBasicStyle($basic_style);
    $self->SetFont(WxMOO::Prefs->prefs->output_font);
}

sub display {
    my ($self, $text) = @_;

    my ($from, $to) = $self->GetSelection;
    $self->SetInsertionPointEnd;

    for my $line (split /\n/, $text) {
        if (WxMOO::Prefs->prefs->use_mcp) {
            next unless ($line = WxMOO::MCP21::output_filter($line));
        }
        if (WxMOO::Prefs->prefs->use_ansi) {
            my $stuff = $self->ansi_parse($line);
            $line = '';
            for my $bit (@$stuff) {
                if (ref $bit) {
                    $self->apply_ansi($bit);
                } else {
                    if (WxMOO::Prefs->prefs->highlight_urls and
                        $bit =~ URL_REGEX) {
                            $self->WriteText(${^PREMATCH});

                            $self->BeginURL(${^MATCH});
                            $self->BeginUnderline;
                            $self->BeginTextColour( Wx::Colour->new(0, 0, 255) );

                            $self->WriteText(${^MATCH});

                            $self->EndTextColour;
                            $self->EndUnderline;
                            $self->EndURL;

                            $self->WriteText(${^POSTMATCH});
                    } else {
                        $self->WriteText($bit);
                    }
                }
            }
        } else {
            $self->WriteText($line);
        }
    }

    if ($from != $to) {
        $self->SetSelection($from, $to);
    }
}

sub focus_input { shift->input_pane->SetFocus; }

my %ansi_colors = (
    black   => [ Wx::Colour->new(  0,  0,  0), Wx::Colour->new(127,127,127) ],
    red     => [ Wx::Colour->new(205,  0,  0), Wx::Colour->new(255,  0,  0) ],
    green   => [ Wx::Colour->new(  0,205,  0), Wx::Colour->new(  0,255,  0) ],
    yellow  => [ Wx::Colour->new(205,205,  0), Wx::Colour->new(255,255,  0) ],
    blue    => [ Wx::Colour->new(  0,  0,238), Wx::Colour->new( 92, 92,255) ],
    magenta => [ Wx::Colour->new(205,  0,205), Wx::Colour->new(255,  0,255) ],
    cyan    => [ Wx::Colour->new(  0,205,205), Wx::Colour->new(  0,255,255) ],
    white   => [ Wx::Colour->new(229,229,229), Wx::Colour->new(255,255,255) ],
);
sub lookup_color {
    my ($self, $color) = @_;
    return $self->{'bright'} ? $ansi_colors{$color}->[1] : $ansi_colors{$color}->[0];
}

sub apply_ansi {
    my ($self, $bit) = @_;
    my ($type, $payload) = @$bit;
    if ($type eq 'control') {
        given ($payload) {
            when ('normal')       {
                my $plain_style = Wx::TextAttr->new;
                if ($self->{'inverse'}) {
                    say STDERR "I'm inverse!";
                    $self->invert_colors;
                }
                $self->SetDefaultStyle($plain_style);
            }
            when ('bold')         { $self->BeginBold;     }
            when ('dim')          { $self->EndBold;       } # TODO - dim further than normal?
            when ('underline')    { $self->BeginUnderline }
            when ('blink')     {
                # TODO - create timer
                # apply style name
                # periodically switch foreground color to background
            }
            when ('inverse')      { $self->invert_colors; }
            when ('hidden')       { 1; }
            when ('strikethru')   { 1; }
            when ('no_bold')      { $self->EndBold; }
            when ('no_underline') { $self->EndUnderline }
            when ('no_blink')  {
                # TODO - remove blink-code-handles style
            }
            when ('no_strikethru') { 1; }
        };
    } elsif ($type eq 'foreground') {
        $self->BeginTextColour($self->lookup_color($payload));
    } elsif ($type eq "background") {
        my $bg_attr = Wx::TextAttr->new;
        $bg_attr->SetBackgroundColour($self->lookup_color($payload));
        $self->SetDefaultStyle($bg_attr);
        # $self->BeginBackgroundColour($self->lookup_color($payload));
    } else {
        say STDERR "unknown ANSI type $type";
    }
}

sub invert_colors {
    my ($self) = @_;
    my $current = $self->GetStyle($self->GetInsertionPoint);
    my $fg = $current->GetTextColour;
    my $bg = $current->GetBackgroundColour;
    # TODO - hrmn current bg color seems to be coming out wrong.

    $current->SetTextColour($bg);
    $current->SetBackgroundColour($fg);

    $self->{'inverse'} = !$self->{'inverse'};
    # $self->SetDefaultStyle($current);  # commenting this out until bg color confusion is resolved
}

my %ansi_codes = (
    0     => [ control => 'normal'        ],
    1     => [ control => 'bold'          ],
    2     => [ control => 'dim'           ],
    4     => [ control => 'underline'     ],
    5     => [ control => 'blink'         ],
    7     => [ control => 'inverse'       ],
    8     => [ control => 'hidden'        ],
    9     => [ control => 'strikethru'    ],
    22    => [ control => 'no_bold'       ], # normal font weight also cancels 'dim'
    24    => [ control => 'no_underline'  ],
    25    => [ control => 'no_blink'      ],
    29    => [ control => 'no_strikethru' ],
    30    => [ foreground => 'black'  ],
    31    => [ foreground => 'red'    ],
    32    => [ foreground => 'green'  ],
    33    => [ foreground => 'yellow' ],
    34    => [ foreground => 'blue'   ],
    35    => [ foreground => 'magenta'],
    36    => [ foreground => 'cyan'   ],
    37    => [ foreground => 'white'  ],

    40    => [ background => 'black'  ],
    41    => [ background => 'red'    ],
    42    => [ background => 'green'  ],
    43    => [ background => 'yellow' ],
    44    => [ background => 'blue'   ],
    45    => [ background => 'magenta'],
    46    => [ background => 'cyan'   ],
    47    => [ background => 'white'  ],
);


sub ansi_parse {
    my ($self, $line) = @_;
    if (my $beepcount = $line =~ s/\007//g) {
        for (1..$beepcount) {
            say STDERR "found a beep";
            Wx::Bell();  # TODO -- "if beep is enabled in the prefs"
        }
    }

    my @bits = split /\e\[(\d+(?:;\d+)*)m/, $line;

    my @styled_text;
    while (my ($i, $val) = each @bits) {
        if ($i % 2) {
            for my $c (split /;/, $val) {
                if (my $style = $ansi_codes{$val}) {
                    push @styled_text, $style;
                }
            }
        } else {
            push @styled_text, $val if $val;
        }
    }
    return [@styled_text];
}

1;
