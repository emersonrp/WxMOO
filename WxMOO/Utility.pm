package WxMOO::Utility;
use strict;
use warnings;
use v5.14;

use parent 'Exporter';
use Wx;

our @EXPORT_OK = qw( id );

sub id { state %ids; $ids{shift()} ||= Wx::NewId; }

"Yes.";
