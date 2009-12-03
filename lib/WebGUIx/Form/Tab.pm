package WebGUIx::Form::Tab;

use Moose;

with 'WebGUIx::Form::Role::HasFields';
with 'WebGUIx::Form::Role::HasFieldsets';
with 'WebGUIx::Form::Role::HasTabsets';

has 'name' => (
    is      => 'rw',
    isa     => 'Str',
);

has 'label' => (
    is      => 'rw',
    isa     => 'Str',
);

1;
