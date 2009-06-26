package Modern::WebGUI::Asset::Base;

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
    'tree' => Modern::WebGUI::Asset::Tree,
    { 'foreign.assetId' => 'self.assetId' },
);


#------------------------------------------------------------------
# WEBGUI API METHODS
# Some of these override parent Moose and DBIx::Class methods

sub add_log { ... }

sub add_revision { ... }

sub can_add { ... }

sub can_edit { ... }

sub can_view { ... }

sub commit { ... }

sub get { ... } # Backwards compat

sub get_all_revision_dates { ... }

sub get_current_revision_date { ... }

sub get_edit_form { ... }

sub get_last_modified { ... }

sub get_toolbar { ... }

sub get_uilevel { ... }

sub get_url { ... }

sub get_version_tag { ... }

sub index_content { ... }

sub is_locked_by { ... }

sub lock { ... }

sub prepare_view { ... }

sub process_edit_form { ... }

sub process_style { ... }

sub process_template { ... }

sub publish { ... }

sub purge { ... }
sub purge_cache { ... }
sub purge_revision { ... }

sub session { ... }

sub unlock { ... }

sub update { ... } # Backwards compat

sub view { ... }

sub www_add { ... }
sub www_add_save { ... }

sub www_change_url { ... }
sub www_change_url_save { ... }

sub www_edit { ... }
sub www_edit_save { ... }

sub www_purge_revision { ... }

sub www_view { ... }

sub www_view_revisions { ... }

1;
