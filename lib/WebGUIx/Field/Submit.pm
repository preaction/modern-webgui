package WebGUIx::Field::Submit;

use Moose;
extends 'WebGUIx::Field';

has 'label' => (
    is      => 'rw',
    isa     => 'Str',
    default => sub { ucfirst shift->name },
    lazy    => 1,
);

sub print {
    my ( $self ) = @_;
    return sprintf '<button type="submit" name="%s" value="%s">%s</button>',
        $self->name, $self->value, $self->label
        ;
}

1;
