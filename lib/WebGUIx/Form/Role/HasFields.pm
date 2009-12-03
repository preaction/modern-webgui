
use MooseX::Declare;
use WebGUIx::Field;

role WebGUIx::Form::Role::HasFields 
    with WebGUIx::Form::Role::HasObjects 
{
    has 'fields' => (
        is      => 'rw',
        isa     => 'HashRef[WebGUIx::Field]',
        default => sub { {} },
    );

    method add_field ( Str $class!, %params ) {
        $class = WebGUIx::Field->load( $class );
        my $field = $class->new( %params );
        push @{$self->objects}, $field;
        $self->fields->{$field->name} = $field;
        return $field;
    }
}

1;
