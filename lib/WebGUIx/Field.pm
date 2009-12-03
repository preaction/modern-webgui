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
    is      => 'rw',
    default => undef,
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
    if ( $INC{$file} || try { require $file; } ) {
        return $load_class;
    }
    elsif ( $INC{'WebGUIx/Field/'.$file} || try { require 'WebGUIx/Field/' . $file } ) {
        return 'WebGUIx::Field::' . $load_class;
    }
    else {
        print $load_class,"\n";
        use Data::Dumper; print Dumper $INC{"WebGUIx/Field/Code.pm"};
        confess sprintf "$@ Could not load field class %s", $load_class;
    }
}

sub print {
    my ( $self ) = @_;
    return sprintf 'Field: %s Value %s' . "\n", $self->name, $self->value;
}

1;
