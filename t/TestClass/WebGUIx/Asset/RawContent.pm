package TestClass::WebGUIx::Asset::RawContent;

use base qw{ TestClass::WebGUIx::Asset };
use WebGUIx::Asset::RawContent;

sub asset_class { return "WebGUIx::Asset::RawContent"; }
sub asset_properties { 
    my ( $class ) = @_;
    my $p   = $class->SUPER::asset_properties;
    $p->{ data }{ status } = "approved";
    return $p;
}

1;
