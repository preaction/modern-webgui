package WebGUIx::Field::Textarea;

use Moose;
extends 'WebGUIx::Field';

sub get_html {
    my ( $self ) = @_;
    return sprintf '<textarea name="%s">%s</textarea>', $self->name, $self->value;
}

1;
