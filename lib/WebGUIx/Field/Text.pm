package WebGUIx::Field::Text;

use Moose;
extends 'WebGUIx::Field';

has 'type' => (
    is      => 'ro',
    default => 'text',
);

1;
