package WebGUIx::Template::Asset;

use Moose;

extends qw{ WebGUIx::Template };
extends qw{ WebGUIx::Asset };

has 'template' => (
    traits  => [qw{ DB Form }],
    is      => 'rw',
    isa     => 'Str',
    default => '',
    form    => {
        field       => 'Code',
    },
);

has 'namespace' => (
    traits  => [qw{ DB Form }],
    is      => 'rw',
    isa     => 'Str',
    form    => {
        field       => 'Text',
    },
);

__PACKAGE__->table( 'template' );

sub get_template {
    my ( $self ) = @_;
    return $self->template;
}

1;
