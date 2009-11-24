package WebGUIx::Field;

# Implement a basic form field 

use Moose;
use Try::Tiny;

has 'name' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has 'value' => (
    is => 'rw',
);

=head2 load ( class )

Load a field class. C<class> can be a full or partial class name. Partial
class names will have 'WebGUIx::Field' prepended.

Returns the class name that was loaded.

If no class could be loaded, throws an error

=cut

sub load {
    my ( $class, $load_class ) = @_;
    my $file    = $load_class;
    $file =~ s{::}{/}g;
    $file .= ".pm";

    # Load the class
    if ( try { require $file; } ) {
        return $load_class;
    }
    elsif ( try { require 'WebGUIx/Field/' . $file } ) {
        return 'WebGUIx::Field::' . $load_class;
    }
    else {
        confess sprintf "Could not load field class %s", $load_class;
    }
}

1;
