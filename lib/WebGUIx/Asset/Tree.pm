package WebGUIx::Asset::Tree;

use Moose;
extends qw{ DBIx::Class };

__PACKAGE__->load_components(qw{ Ordered Core });

__PACKAGE__->table( 'asset' );
__PACKAGE__->add_columns(qw{
    assetId className state parentId rank lineage creationDate
});
__PACKAGE__->set_primary_key( 'assetId' );
__PACKAGE__->position_column( 'rank' );
__PACKAGE__->grouping_column( 'parentId' );

#----------------------------------------------------------------------------

=head2 inflate_result ( ... )

Override inflate_result() to provide dynamic subclassing.

=cut

sub inflate_result { 
    my $self    = shift;  
    my $asset   = $self->next::method(@_); 
    if ( ref $asset eq 'WebGUIx::Asset::Tree' ) {
        # This doesn't work, because every WebGUIx::Asset object
        # contains one of these objects.
    } 
    return $asset; 
} 

1;
