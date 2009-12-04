package WebGUIx::Field::Readonly;

use Moose;
extends 'WebGUIx::Field';

sub print {
    my ( $self ) = @_;
    return $self->value;
}

1;
