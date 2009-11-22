package WebGUIx::Meta::Attribute::Trait::DB;

use Moose::Role;

has 'db' => (
    is      => 'ro',
    isa     => 'HashRef',
);

package Moose::Meta::Attribute::Custom::Trait::DB;
sub register_implementation { 'WebGUIx::Meta::Attribute::Trait::DB' }

1;

