package WebGUIx::Asset::Template;

use Moose;
extends qw{ DBIx::Class };
#with 'WebGUIx::Asset::Role::Common';

__PACKAGE__->load_components(qw{ Core });

__PACKAGE__->table( 'template' );
__PACKAGE__->add_columns(qw{ 
    assetId revisionDate
    template
});
__PACKAGE__->set_primary_key( 'assetId', 'revisionDate' );
__PACKAGE__->belongs_to(
    'base' => 'WebGUIx::Asset::Base',
    { 
        'foreign.assetId'         => 'self.assetId',
        'foreign.revisionDate'    => 'self.revisionDate',
    }
);


#------------------------------------------------------------------
# WEBGUI API METHODS
# Some of these override parent Moose and DBIx::Class methods
# Template assets


# add_param ( hashref )
# Add parameters to this template
# Allow sub { } for lazyload
# Allow template objects for lazy printing
# Allow templates to be included and have access to outer vars

1;
