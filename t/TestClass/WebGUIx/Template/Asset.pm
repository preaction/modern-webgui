package TestClass::WebGUIx::Template::Asset;

use Moose;
extends qw{ TestClass::WebGUIx::Asset };

sub asset_class { return "WebGUIx::Template::Asset"; }
override form_properties => sub {
    return {
        %{super()},
        namespace       => 'test_namespace',
    };
};

1;
