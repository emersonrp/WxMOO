package WxMOO::Utility;
use perl5i::2;
use parent 'Exporter';
use Wx;

our @EXPORT_OK = qw( id );

func id($item) { state %ids; $ids{$item} ||= Wx::NewId; }

"Yes.";
