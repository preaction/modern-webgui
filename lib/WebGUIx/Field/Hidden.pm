package WebGUIx::Field::Hidden;

use Moose;
extends 'WebGUIx::Field';

has 'type' => (
    is          => 'ro',
    default     => 'hidden',
);

1;
