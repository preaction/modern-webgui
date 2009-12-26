package WebGUIx::Form::Fieldset;

use Moose;

has 'name' => (
    is      => 'rw',
    isa     => 'Str',
);

has 'label' => (
    is      => 'rw',
    isa     => 'Str',
);

has 'session' => (
    is          => 'ro',
    isa         => 'WebGUI::Session',
    required    => 1,
);

with 'WebGUIx::Form::Role::HasFields';
with 'WebGUIx::Form::Role::HasFieldsets';
with 'WebGUIx::Form::Role::HasTabsets';

1;
