package WebGUIx::Model;

use Moose;
use MooseX::Declare;

extends qw{ DBIx::Class };

__PACKAGE__->load_components(qw{ VirtualColumns Core });

# Base class for all WebGUI models

sub table {
    my ( $class, $table ) = @_;
    $class->next::method( $table );
    $class->add_virtual_columns(qw{ session });
}


1;
