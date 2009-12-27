package WebGUIx::Asset::Schema;

# This class is for Assets as collections or to find specific assets

use Moose;
use Module::Find;
extends 'DBIx::Class::Schema';

has 'session' => (
    is          => 'rw',
    isa         => 'WebGUI::Session',
);

my $exclude = qr{ 
      Schema$           # Don't load schema
    | ::Role::          # Don't load roles
}x;
my @assets  = grep { !/$exclude/ } findallmod 'WebGUIx::Asset';
__PACKAGE__->load_classes( {
    'WebGUIx::Asset' => [ map { s/WebGUIx::Asset:://; $_ } @assets ],
    'WebGUIx::Template' => [ qw{ Asset } ],
} );

sub new {
    my ( $class, $session ) = @_;
    my $self    = $class->next::method;
    $self->session( $session );
}

1;
