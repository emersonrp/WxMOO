package WxMOO::Utility;
use strict;
use warnings;
use v5.14;

use Method::Signatures;

use parent 'Exporter';
use Wx;

our @EXPORT_OK = qw( id );

func id($item) { state %ids; $ids{$item} ||= Wx::NewId; }

"Yes.";
