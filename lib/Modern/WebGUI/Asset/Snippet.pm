package Modern::WebGUI::Asset::Snippet;

use Moose;
extends 'DBIx::Class';
__PACKAGE__->load_components(qw{ Core });

__PACKAGE__->table( 'snippet' );
__PACKAGE__->add_columns(qw{ 
    assetId revisionDate
    snippet processAsTemplate mimeType cacheTimeout
    snippetPacked usePacked
});
__PACKAGE__->set_primary_key( 'assetId', 'revisionDate' );
__PACKAGE__->belongs_to(
    'base' => 'Modern::WebGUI::Asset::Base',
    { 
        'foreign.assetId'         => 'self.assetId',
        'foreign.revisionDate'    => 'self.revisionDate',
    }
);


#------------------------------------------------------------------
# WEBGUI API METHODS
# Some of these override parent Moose and DBIx::Class methods


1;

