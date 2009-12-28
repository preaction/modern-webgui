package WebGUIx::Asset::Role::Versioning;

use Moose::Role;
use WebGUI::VersionTag;

#----------------------------------------------------------------------------

=head2 add_revision ( )

Create a new revision of this asset. Returns the object pointing to the new
revision.

=cut


sub add_revision { 
    my ( $self, %props ) = @_;
    $props{revisionDate} ||= time+2;
    $props{data}{revisionDate}  = $props{revisionDate};
    $props{data}{assetId}       = $props{assetId} || $self->assetId;

    # XXX: Create a version tag if necessary
    
    my $new_data        = $self->data->copy( delete $props{data} );
    my $new_revision    = $self->copy( \%props );
    $new_revision->tree( $self->tree );
    $new_revision->data( $new_data );

    return $new_revision;
}

sub commit { 
    my ( $self ) = @_;

    # XXX: TODO

    return;
}

#----------------------------------------------------------------------------

=head2 get_all_revisions ( )

Get a ResultSet with all the revisions of this asset.

=cut

sub get_all_revisions {
    my ( $self ) = @_;
    my $schema      = $self->result_source->schema;
    return $schema->resultset('Any')->search( { assetId => $self->assetId } );
}

#----------------------------------------------------------------------------

=head2 CLASS->get_current_revision_date ( session, asset_id )

Get the most current revision date the user should see. If the user is inside
of a version tag, show them their latest changes. Otherwise show the latest
committed version.

=cut

sub get_current_revision_date {
    my ( $class, $session, $asset_id ) = @_;
    my $schema = $session->{_schema};

    my %tag     = ();
    if ( my $tag = WebGUI::VersionTag->getWorking( $session, "nocreate" ) ) {
        $tag{ -and } = [ 
            tagId   => $tag->getId,
            status  => "pending",
        ];
    }

    my $row
        = $schema->resultset('Any')->search({
            -and => [
                assetId => $asset_id,
                -or => [
                    -or => [
                        status      => { '!=' => "pending" },
                        status      => \"IS NULL",
                    ],
                    %tag,
                ],
            ],
        }, {
            order_by    => { -desc => 'revisionDate' },
            columns     => [ 'revisionDate' ],
            cache       => 1,
        })
        ->single;

    return $row->revisionDate;
}

#sub get_toolbar { ... }
#sub get_version_tag { ... }
#sub process_edit_form { ... }
#sub purge { ... }
#sub purge_revision { ... }
#sub www_purge_revision { ... }
#sub www_view_revisions { ... }

1;
