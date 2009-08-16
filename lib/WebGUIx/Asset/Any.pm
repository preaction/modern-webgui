package WebGUIx::Asset::Any;

use Moose;
extends qw{ DBIx::Class };

__PACKAGE__->load_components(qw{ Core });

__PACKAGE__->table( 'assetData' );
__PACKAGE__->add_columns(qw{
    assetId revisionDate revisedBy tagId status title menuTitle url 
    ownerUserId groupIdView groupIdEdit synopsis
});
__PACKAGE__->set_primary_key( 'assetId', 'revisionDate' );
__PACKAGE__->belongs_to(
    'tree' => 'WebGUIx::Asset::Tree',
    { 
        'foreign.assetId' => 'self.assetId'
    },
);

# Add automatic revisionDate finding

#----------------------------------------------------------------------------

=head2 inflate_result ( ... )

Override inflate_result() to provide dynamic subclassing.

=cut

sub inflate_result { 
    my $self    = shift;  
    my $asset   = $self->next::method(@_); 
    if ( ref $asset eq 'WebGUIx::Asset::Any' ) {
        # This doesn't work because every WebGUIx::Asset object
        # contains one of these objects.
    } 
    return $asset; 
} 

1;
