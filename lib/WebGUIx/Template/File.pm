package WebGUIx::Template::File;

use Moose;
extends 'WebGUIx::Template';

has 'file' => (
    is      => 'rw',
    isa     => 'Str',
);

sub get_template {
    my ( $self ) = @_;
    return $self->file;
}

1;
