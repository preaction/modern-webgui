package WebGUIx::Asset::Snippet;

use Moose;
extends qw{ DBIx::Class };

__PACKAGE__->load_components(qw{ Core });

__PACKAGE__->table( 'snippet' );
__PACKAGE__->add_columns(qw{ 
    assetId revisionDate
    snippet processAsTemplate mimeType cacheTimeout
    snippetPacked usePacked
});
__PACKAGE__->set_primary_key( 'assetId', 'revisionDate' );
__PACKAGE__->belongs_to(
    'base' => 'WebGUIx::Asset::Any',
    { 
        'foreign.assetId'         => 'self.assetId',
        'foreign.revisionDate'    => 'self.revisionDate',
    }
);
__PACKAGE__->belongs_to(
    'tree' => 'WebGUIx::Asset::Tree',
    { 'foreign.assetId' => 'self.assetId' },
);


with 'WebGUIx::Asset::Role::Common';
with 'WebGUIx::Asset::Role::Versioning';

#------------------------------------------------------------------
# Snippet-specific methods


1;

