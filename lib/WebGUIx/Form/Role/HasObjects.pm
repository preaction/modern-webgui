package WebGUIx::Form::Role::HasObjects;

use Moose::Role;

with 'WebGUIx::Form::Role::HasObjects';

has 'objects' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { [] },
);

sub print_objects {
    my ( $self ) = @_;
    my $html    = join '', map { $_->print } @{$self->objects};
    return $html;
}

1;

