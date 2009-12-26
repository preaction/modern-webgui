
use MooseX::Declare;

role WebGUIx::Form::Role::HasFields 
    with WebGUIx::Form::Role::HasObjects 
{
    use WebGUIx::Field;

    requires 'session';

    has 'fields' => (
        is      => 'rw',
        isa     => 'HashRef[WebGUIx::Field]',
        default => sub { {} },
    );

    method add_field ( @args ) {
        my $field;
        if ( scalar @args == 1 && $args[0]->isa( 'WebGUIx::Field' ) ) {
            $field  = $args[0];
        }
        else {
            my $class = WebGUIx::Field->load( $args[0] );
            my %params = @args[1..$#args];
            $params{ session } = $self->session;
            $field = $class->new( %params );
        }
        push @{$self->objects}, $field;
        $self->fields->{$field->name} = $field;
        return $field;
    }

    method process () {
        my %var = ();
        for my $obj ( @{$self->objects} ) {
            if ( $obj->isa('WebGUIx::Field') ) {
                $var{ $obj->name } = $obj->get_value;
            }
            else {
                %var = ( %var, %{$obj->process} );
            }
        }
        return \%var;
    }

}

1;
