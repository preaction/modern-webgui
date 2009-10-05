package WebGUIx::Model;

use Moose;
use MooseX::Declare;

extends qw{ DBIx::Class };

__PACKAGE__->load_components(qw{ Core });

# Base class for all WebGUI models

sub table {
    my ( $class, $table ) = @_;
    $class->next::method( $table );
}


1;
