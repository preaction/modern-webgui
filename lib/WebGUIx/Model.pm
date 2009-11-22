package WebGUIx::Model;

use Moose;
use MooseX::Declare;
use WebGUIx::Meta::Attribute::Trait::DB;

extends qw{ DBIx::Class };

__PACKAGE__->load_components(qw{ VirtualColumns Core });

# Base class for all WebGUI models

sub table {
    my ( $class, $table ) = @_;

    $class->next::method( $table );

    # Add any moose properties
    my $meta        = $class->meta;
    my @primary_key = ();
    for my $attr ( $meta->get_all_attributes ) {
        if ( $attr->does('WebGUIx::Meta::Attribute::Trait::DB') ) {
            $class->add_column( $attr->name );
            if ( $attr->db->{primary_key} ) {
                push @primary_key, $attr->name;
            }
        }
        else {
            $class->add_virtual_column( $attr->name );
        }
    } 
    if ( @primary_key ) {
        $class->set_primary_key( @primary_key );
    }
}


1;
