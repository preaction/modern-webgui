package WebGUIx::Meta::Attribute::Trait::Form;

use Moose::Role;

has 'form' => (
    is      => 'ro',
    isa     => 'HashRef',
);

package Moose::Meta::Attribute::Custom::Trait::Form;
sub register_implementation { 'WebGUIx::Meta::Attribute::Trait::Form' }

1;

