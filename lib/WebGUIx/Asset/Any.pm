package WebGUIx::Asset::Any;

use Moose;
extends 'DBIx::Class';
__PACKAGE__->load_components(qw{ Core });

__PACKAGE__->table( 'assetData' );
__PACKAGE__->add_columns(qw{
    assetId revisionDate revisedBy tagId status title menuTitle url 
    ownerUserId groupIdView groupIdEdit synopsis
});
__PACKAGE__->set_primary_key( 'assetId', 'revisionDate' );

1;
