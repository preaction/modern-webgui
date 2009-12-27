package t::WebGUIx::Template::Asset;

use Moose;
use Test::Suite;
extends qw{ t::WebGUIx::Asset };

sub asset_class { return "WebGUIx::Template::Asset"; }
override form_properties => sub {
    return {
        %{super()},
        namespace       => 'test_namespace',
    };
};

1;
