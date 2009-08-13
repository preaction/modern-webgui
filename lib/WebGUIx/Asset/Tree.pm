package WebGUIx::Asset::Tree;

use Moose;

extends qw{ DBIx::Class };
__PACKAGE__->load_components(qw{ Ordered Core });

__PACKAGE__->table( 'asset' );
__PACKAGE__->add_columns(qw{
    assetId className state parentId rank
});
__PACKAGE__->set_primary_key( 'assetId' );
__PACKAGE__->position_column( 'rank' );
__PACKAGE__->grouping_column( 'parentId' );

# Add dynamic subclassing


1;
