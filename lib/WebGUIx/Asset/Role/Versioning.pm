package WebGUIx::Asset::Role::Versioning;

use Moose::Role;


#----------------------------------------------------------------------------

=head2 add_revision ( )

Create a new revision of this asset. Returns the object pointing to the new
revision.

=cut


sub add_revision { 
    my ( $self ) = @_;    
    
}

#sub commit { ... }
#sub get_all_revision_dates { ... }
#sub get_current_revision_date { ... }
#sub get_toolbar { ... }
#sub get_version_tag { ... }
#sub process_edit_form { ... }
#sub purge { ... }
#sub purge_revision { ... }
#sub www_purge_revision { ... }
#sub www_view_revisions { ... }

1;
