package WebGUIx::Form::Role::HasObjects;

use Moose::Role;

has 'objects' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { [] },
);

sub combine {
    my ( $self, $object ) = @_;
    
    for my $o ( @{ $object->objects } ) {
        if ( $o->isa( 'WebGUIx::Field' ) ) {
            next if ( $self->fields->{ $o->name } );
            $self->add_field( $o );
        }
        elsif ( $o->isa( 'WebGUIx::Form::Tabset' ) ) {
            if ( $self->tabsets->{ $o->name } ) {
                $self->tabsets->{ $o->name }->combine( $o );
            }
            else {
                $self->add_tabset( $o );
            }
        }
        elsif ( $o->isa( 'WebGUIx::Form::Fieldset' ) ) {
            if ( $self->fieldsets->{ $o->name } ) {
                $self->fieldsets->{ $o->name }->combine( $o );
            }
            else {
                $self->add_fieldset( $o );
            }
        }
    }
}

sub print_objects {
    my ( $self ) = @_;
    my $html    = join '', map { $_->print } @{$self->objects};
    return $html;
}

1;

