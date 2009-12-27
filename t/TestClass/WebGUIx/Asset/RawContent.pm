package TestClass::WebGUIx::Asset::RawContent;

use Moose;
use WebGUIx::Asset::RawContent;

extends qw{ TestClass::WebGUIx::Asset };
with 'TestClass::WebGUIx::Asset::Role::Versioning';

sub asset_class { return "WebGUIx::Asset::RawContent"; }
around asset_properties => sub { 
    my ( $orig ) = @_;
    my $p   = $orig->();
    return $p;
};

1;
