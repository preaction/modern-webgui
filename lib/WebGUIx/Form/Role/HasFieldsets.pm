package WebGUIx::Form::Role::HasFieldsets;

use Moose::Role;

with 'WebGUIx::Form::Role::HasObjects';

has 'fieldsets' => (
    is      => 'rw',
    isa     => 'HashRef[WebGUIx::Form::Fieldset]',
    default => sub { {} },
);

1;
