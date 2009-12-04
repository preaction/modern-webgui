
use MooseX::Declare;

role WebGUIx::Form::Role::HasFields 
    with WebGUIx::Form::Role::HasObjects 
{
    use WebGUIx::Field;

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

    method process ( $session ) {
        my %var = ();
        for my $obj ( @{$self->objects} ) {
            if ( $obj->isa('WebGUIx::Field') ) {
                $var{ $obj->name } = $obj->get_value( $session );
            }
            else {
                %var = ( %var, %{$obj->process( $session )} );
            }
        }
        return \%var;
    }

}

1;
