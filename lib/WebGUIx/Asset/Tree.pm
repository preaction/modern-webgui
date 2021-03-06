package WebGUIx::Asset::Tree;

use Moose;
extends qw{ WebGUIx::Model };

__PACKAGE__->load_components(qw{ Ordered });

has 'parentId' => (
    traits  => [qw/ DB /],
    is      => 'rw',
    isa     => 'Str',
    db      => {
        size        => 22,
    },
);

has 'className' => (
    traits  => [qw/ DB /],
    is      => 'rw',
    isa     => 'Str',
);

__PACKAGE__->table( 'asset' );
__PACKAGE__->add_columns(qw{
    assetId state rank lineage creationDate
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

=head2 as_asset ( session )

Return the result as the WebGUIx::Asset subtype.

=cut

sub as_asset {
    my ( $self, $session ) = @_;
    my ( $src ) = $self->className =~ m/([^:]+)$/;
    my $revisionDate = $self->className->get_current_revision_date(
        $session,
        $self->assetId,
    );
    return $self->result_source->schema->resultset( $src )->find({
        assetId         => $self->assetId,
        revisionDate    => $revisionDate,
    });
}

1;
