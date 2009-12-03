package WebGUIx::Asset::Schema;

# This class is for Assets as collections or to find specific assets

use Moose;
use Module::Find;
extends 'DBIx::Class::Schema';
my $exclude = qr{ 
      Schema$           # Don't load schema
    | ::Role::          # Don't load roles
}x;
my @assets  = grep { !/$exclude/ } findallmod 'WebGUIx::Asset';
__PACKAGE__->load_classes( {
    'WebGUIx::Asset' => [ map { s/WebGUIx::Asset:://; $_ } @assets ],
    'WebGUIx::Template' => [ qw{ Asset } ],
} );

1;
