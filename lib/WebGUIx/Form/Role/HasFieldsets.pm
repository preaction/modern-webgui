package WebGUIx::Form::Role::HasFieldsets;

use Moose::Role;

with 'WebGUIx::Form::Role::HasObjects';

requires 'session';

has 'fieldsets' => (
    is      => 'rw',
    isa     => 'HashRef[WebGUIx::Form::Fieldset]',
    default => sub { {} },
);

sub add_fieldset {
    my ( $self, @args ) = @_;
    my $fieldset;

    if ( scalar @args == 1 ) {
        $fieldset = $args[0];
    }
    else {
        push @args, session => $self->session;
        $fieldset = WebGUIx::Form::Fieldset->new( @args );
    }

    push @{$self->objects}, $fieldset;
    $self->fieldsets->{ $fieldset->name } = $fieldset;
    return $fieldset;
}

1;
