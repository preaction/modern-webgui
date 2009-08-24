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

#----------------------------------------------------------------------------

=head2 as_asset ( )

Return the result as the WebGUIx::Asset subtype.

=cut

sub as_asset {
    my ( $self ) = @_;
    my ( $src ) = $self->tree->className =~ m/([^:]+)$/;
    return $self->result_source->schema->resultset( $src )->find({
        assetId         => $self->assetId,
        revisionDate    => $self->revisionDate,
        },
    );
}

1;
