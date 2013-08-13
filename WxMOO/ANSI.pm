package WxMOO::ANSI;
use perl5i::2;
use WxMOO::Theme;

my %ansi_control_codes = (
    0     => 'reset',
    1     => 'bright',
    2     => 'dim',
    4     => 'underline',
    5     => 'blink',
    7     => 'reverse',
    8     => 'hidden',
);
my %ansi_color_codes = (
    30    => 'fg_black',
    31    => 'fg_red',
    32    => 'fg_green',
    33    => 'fg_yellow',
    34    => 'fg_blue',
    35    => 'fg_magenta',
    36    => 'fg_cyan',
    37    => 'fg_white',
    40    => 'bg_black',
    41    => 'bg_red',
    42    => 'bg_green',
    43    => 'bg_yellow',
    44    => 'bg_blue',
    45    => 'bg_magenta',
    46    => 'bg_cyan',
    47    => 'bg_white',
);
my %ansi_codes = ( %ansi_control_codes, %ansi_color_codes );

my $theme = WxMOO::Theme->new;

func output_filter {
    my @bits = split /\e\[(\d+(?:;\d+)*)m/, shift;

    my @styledText;
    while (my ($i, $val) = each @bits) {
        if ($i % 2) {
            for my $c (split /;/, $val) {
                # TODO - pass along [ style, starting_loc ]
                # push @styledText, $val;
            }
        } else {
            push @styledText, $val;
        }
    }
    return [@styledText];
}

my $stylesheet = eval {
    my $stylesheet = Wx::RichTextStyleSheet->new;

    for my $c (values %ansi_color_codes) {
        my $style = Wx::RichTextCharacterStyleDefinition->new($c);
        my $attr  = Wx::RichTextAttr->new;
        my ($bgfg, $colorName) = split /_/, $c;
        my $colour = $theme->get_wxColour("$colorName");
        if ($bgfg eq 'fg') {
            $attr->SetBackgroundColour( $colour );
        } else {
            $attr->SetTextColour( $colour );
        }
        $style->SetStyle($attr);
        $stylesheet->AddCharacterStyle($style);
    }

    return $stylesheet;
};
