package WebGUIx::Field::Hidden;

use Moose;
extends 'WebGUIx::Field';

has 'type' => (
    is          => 'ro',
    default     => 'hidden',
);

sub print {
    my ( $self ) = @_;
    return $self->get_html;
}

1;
