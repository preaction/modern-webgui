package WebGUIx::Field::Readonly;

use Moose;
extends 'WebGUIx::Field';

sub get_html {
    my ( $self ) = @_;
    return $self->value;
}

1;
