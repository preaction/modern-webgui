package WebGUIx::Asset::Tree;

use Moose;
extends qw{ WebGUIx::Model };

__PACKAGE__->load_components(qw{ Ordered });

__PACKAGE__->table( 'asset' );
__PACKAGE__->add_columns(qw{
    assetId className state parentId rank lineage creationDate
});
__PACKAGE__->set_primary_key( 'assetId' );
__PACKAGE__->position_column( 'rank' );
__PACKAGE__->grouping_column( 'parentId' );
__PACKAGE__->has_many(
    'data'  => 'WebGUIx::Asset::Any',
    {
        'foreign.assetId' => 'self.assetId',
    },
);

#----------------------------------------------------------------------------

=head2 as_asset ( )

Return the result as the WebGUIx::Asset subtype.

=cut

sub as_asset {
    my ( $self ) = @_;
    my ( $src ) = $self->className =~ m/([^:]+)$/;
    my $revisionDate = $self->className->get_current_revision_date(
        $self->result_source->schema,
        $self->assetId,
    );
    return $self->result_source->schema->resultset( $src )->find({
        assetId         => $self->assetId,
        revisionDate    => $revisionDate,
    });
}

1;
