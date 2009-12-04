package WebGUIx::Field;

# Implement a basic form field 

use Moose;
use Try::Tiny;

has 'label' => (
    is      => 'rw',
    isa     => 'Str',
    default => sub { ucfirst shift->name },
    lazy    => 1,
);

has 'name' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has 'value' => (
    is      => 'rw',
    default => undef,
);

has 'type' => (
    is      => 'rw',
    isa     => 'Str',
    default => undef,
);

=head1 METHODS

#----------------------------------------------------------------------------

=head2 get_html ( ) 

Get the HTML for this field

=cut

sub get_html {
    my ( $self ) = @_;
    return sprintf '<input type="%s" name="%s" value="%s" %s />',
        $self->type, $self->name, $self->value
        ;
}

#----------------------------------------------------------------------------

=head2 get_value ( session )

Get the value from the form.

=cut

sub get_value {
    my ( $self, $session ) = @_;
    return $session->form->get( $self->name );
}

#----------------------------------------------------------------------------

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
    # Try to load the WebGUIx::Field in case we conveniently overlap with a common name
    # (like Readonly)
    if ( $INC{'WebGUIx/Field/'.$file} || try { require 'WebGUIx/Field/' . $file } ) {
        return 'WebGUIx::Field::' . $load_class;
    }
    elsif ( $INC{$file} || try { require $file; } ) {
        return $load_class;
    }
    else {
        confess sprintf "Could not load field class %s", $load_class;
    }
}

#----------------------------------------------------------------------------

sub print {
    my ( $self ) = @_;
    return sprintf '<label>%s<br/>%s</label>', $self->label, $self->get_html;
}

1;
