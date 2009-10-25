package WebGUIx::Asset::Role::Compatible;

# Compatibility with existing WebGUI API

use Moose::Role;

sub canEdit {
    my ( $self, @args ) = @_;
    return $self->can_edit( @args );
}

sub canEditIfLocked {
    my ( $self, @args ) = @_;
    return $self->can_edit( @args );
}

sub canView {
    my ( $self, @args ) = @_;
    return $self->can_view( @args );
}

sub get {
    my ( $self, $param ) = @_;

    my %params = (
        $self->get_inflated_columns,
        $self->tree->get_inflated_columns,
        $self->data->get_inflated_columns
    );

    # TODO: All relationships should be included in %params

    if ( $param ) {
        return $params{ $param };
    }
    else {
        return \%params;
    }
}

sub getChildCount {
    my ( $self ) = @_;
    return $self->get_children->count;
}

sub getContentLastModified {
    my ( $self ) = @_;
    return $self->revisionDate;
}

sub getCurrentRevisionDate { 
    my ( $class, $session, $asset_id ) = @_;
    return $class->get_current_revision_date( $session, $asset_id );
}

sub getIcon {
    my ( $self ) = @_; 
    return ''; ### TODO
}

sub getId {
    my ( $self ) = @_;
    return $self->assetId;
}

sub getName {
    my ( $self ) = @_;
    return "MyName"; ### TODO
}

sub getUrl {
    my ( $self, @args ) = @_;
    return $self->get_url( @args );
}

sub hasChildren {
    my ( $self ) = @_;
    return $self->has_children;
}

sub new {
    my ( $class, @args ) = @_;
    
    if ( Scalar::Util::blessed( $args[0] ) && $args[0]->isa('WebGUI::Session') ) {
        my ( $session, $assetId, $className, $revisionDate ) = @args;
        $session->log->info( 
            sprintf 'Trying to instantiate asset %s %s %s', $className, $assetId, $revisionDate 
        );
        my $schema  = WebGUIx::Asset::Schema->connect( sub { $session->db->dbh } );
        
        my %revisionDate    = ();
        if ( $revisionDate ) {
            $revisionDate{ revisionDate } = $revisionDate;
        }

        my $row     = $schema->resultset('Any')->find({
            assetId         => $assetId,
            %revisionDate,
        });
        my $asset   = $row->as_asset;
        $asset->session( $session );
        return $asset;
    }
    else {
        return $class->SUPER( @args );
    }
}

1;
