package WebGUIx::Field::Textarea;

use Moose;
extends 'WebGUIx::Field';

sub print {
    my ( $self ) = @_;
    return sprintf '<textarea name="%s">%s</textarea>', $self->name, $self->value;
}

1;
