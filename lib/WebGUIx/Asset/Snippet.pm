package WebGUIx::Asset::Snippet;

use Moose;
extends qw{ DBIx::Class };
with 'WebGUIx::Asset::Role::Versioning';

__PACKAGE__->load_components(qw{ +WebGUIx::Asset VirtualColumns Core });

__PACKAGE__->table( 'snippet' );
__PACKAGE__->add_virtual_columns(qw{ session });
__PACKAGE__->add_columns(qw{ 
    assetId revisionDate
    snippet processAsTemplate mimeType cacheTimeout
    snippetPacked usePacked
});
__PACKAGE__->set_primary_key( 'assetId', 'revisionDate' );
__PACKAGE__->belongs_to(
    'data' => 'WebGUIx::Asset::Any',
    { 
        'foreign.assetId'         => 'self.assetId',
        'foreign.revisionDate'    => 'self.revisionDate',
    },
);
__PACKAGE__->belongs_to(
    'tree' => 'WebGUIx::Asset::Tree',
    { 
        'foreign.assetId' => 'self.assetId'
    },
);


#------------------------------------------------------------------
# Snippet-specific methods


1;

