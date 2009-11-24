package WebGUIx::Field::Text;

use Moose;
extends 'WebGUIx::Field';

sub to_html {
    my ( $self ) = @_;
    return sprintf '<input type="text" name="%s" value="%s" />', $self->name, $self->value;
}

1;
