package WebGUIx::Form::Role::HasTabsets;

use Moose::Role;

with 'WebGUIx::Form::Role::HasObjects';

has 'tabsets' => (
    is      => 'rw',
    isa     => 'HashRef[WebGUIx::Form::Tabset]',
    default => sub { {} },
);


1;
