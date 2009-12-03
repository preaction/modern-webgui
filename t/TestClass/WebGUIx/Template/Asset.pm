package TestClass::WebGUIx::Template::Asset;

use Moose;
extends qw{ TestClass::WebGUIx::Asset };

sub asset_class { return "WebGUIx::Template::Asset"; }


1;
