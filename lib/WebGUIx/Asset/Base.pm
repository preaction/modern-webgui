package WebGUIx::Asset::Base;

# This is the base class of all assets and implements versioning
# and all other single-asset methods

use strict;
use warnings;

use Moose;
extends 'DBIx::Class';
__PACKAGE__->load_components(qw{ Core });

__PACKAGE__->table( 'assetData' );
__PACKAGE__->add_columns(qw{
    assetId revisionDate revisedBy tagId status title menuTitle url 
    ownerUserId groupIdView groupIdEdit synopsis
});
__PACKAGE__->set_primary_key( 'assetId', 'revisionDate' );
__PACKAGE__->belongs_to( 
    'tree' => 'WebGUIx::Asset::Tree',
    { 'foreign.assetId' => 'self.assetId' },
);


#----------------------------------------------------------------------------
# WEBGUI API METHODS
# Some of these override parent Moose and DBIx::Class methods

#sub get_all_revision_dates { ... }




#sub get_version_tag { ... }


#sub is_locked_by { ... }

#sub lock { ... }




#sub unlock { ... }

1;
