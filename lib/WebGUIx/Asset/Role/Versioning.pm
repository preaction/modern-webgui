package WebGUIx::Asset::Role::Versioning;

use Moose::Role;


#----------------------------------------------------------------------------

=head2 add_revision ( )

Create a new revision of this asset. Returns the object pointing to the new
revision.

=cut


sub add_revision { 
    my ( $self ) = @_;
    my $revision_date   = time;

    # Create a version tag if necessary

    $self->data->copy( { revisionDate => $revision_date } );
    my $new_revision    = $self->copy( { revisionDate => $revision_date } );
    return $new_revision;
}

#sub commit { ... }

#----------------------------------------------------------------------------

=head2 get_all_revisions ( )

Get a ResultSet with all the revisions of this asset.

=cut

sub get_all_revisions {
    my ( $self ) = @_;
    my $schema      = $self->result_source->schema;
    return $schema->resultset('Any')->search( { assetId => $self->assetId } );
}

#sub get_current_revision_date { ... }
#sub get_toolbar { ... }
#sub get_version_tag { ... }
#sub process_edit_form { ... }
#sub purge { ... }
#sub purge_revision { ... }
#sub www_purge_revision { ... }
#sub www_view_revisions { ... }

1;
