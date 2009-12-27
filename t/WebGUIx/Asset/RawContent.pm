package t::WebGUIx::Asset::RawContent;

use Moose;
use Test::Sweet;
use WebGUIx::Asset::RawContent;

extends qw{ t::WebGUIx::Asset };
with 't::WebGUIx::Asset::Role::Compatible';

sub asset_class { return "WebGUIx::Asset::RawContent"; }
around asset_properties => sub { 
    my ( $orig ) = @_;
    my $p   = $orig->();
    return $p;
};

1;
