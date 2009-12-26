package WebGUIx::Form::Tab;

use Moose;

has 'name' => (
    is      => 'rw',
    isa     => 'Str',
);

has 'label' => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => sub { return ucfirst shift->name },
);

has 'session' => (
    is          => 'ro',
    isa         => 'WebGUI::Session',
    required    => 1,
);

with 'WebGUIx::Form::Role::HasFields';
with 'WebGUIx::Form::Role::HasFieldsets';
with 'WebGUIx::Form::Role::HasTabsets';

sub print {
    my ( $self ) = @_;
    return $self->print_objects;
}

1;
