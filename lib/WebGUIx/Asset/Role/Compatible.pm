package WebGUIx::Asset::Role::Compatible;

# Compatibility with existing WebGUI API

use Moose::Role;
use WebGUIx::Asset::Schema;

sub _caller_is_old {
    my $i = 1;
    while ( my ( $package, @ignore ) = caller( $i ) ) {
        return 1 if $package eq "WebGUI::Content::Asset";
        $i++;
    }
    return 0;
}

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

around new => sub {
    my ( $orig, $class, @args ) = @_;
    
    # Being called by old WebGUI
    if ( _caller_is_old() ) {
        my ( $session, $assetId, $className, $revisionDate ) = @args;

        my $schema;
        unless ( $schema = $session->{_schema} ) {
            $schema = $session->{_schema} 
                    = WebGUIx::Asset::Schema->connect( sub { $session->db->dbh } );
        }
        
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

    # Not being called by old WebGUI
    return $class->$orig(@args);
};

around www_add => sub {
    my ( $orig, $self, @args ) = @_;
    my $tmpl;

    # Being called by old WebGUI
    if ( _caller_is_old() ) {
        $tmpl = $self->$orig($self->session,@args);
        unless ( my $schema = $self->session->{_schema} ) {
            $schema = $self->session->{_schema} 
                    = WebGUIx::Asset::Schema->connect( sub { $self->session->db->dbh } );
        }
    }
    else {
        $tmpl = $self->$orig(@args);
    }

    if ( _caller_is_old() ) {
        # Adding a WebGUIx asset
        if ( Scalar::Util::blessed( $tmpl ) && $tmpl->isa( 'WebGUIx::Template' ) ) {
            # XXX: This needs to be in config file
            $tmpl->tt_options->{INCLUDE_PATH} = "/data/modern-webgui/tmpl"; 
            my $output = '';
            $tmpl->process(\$output)
            || $self->session->log->error("Couldn't process template: " . $tmpl->error );
            return $output;
        }
    }

    # Adding an old WebGUI asset
    return $tmpl;
};

around www_edit => sub {
    my ( $orig, $self, @args ) = @_;
    
    # Being called by old WebGUI
    if ( _caller_is_old() ) {
        my $tmpl   = $self->$orig( $self->session, @args );
        # XXX: This needs to be in config file
        $tmpl->tt_options->{INCLUDE_PATH} = "/data/modern-webgui/tmpl"; 

        my $output = '';
        $tmpl->process(\$output)
            || $self->session->log->error("Couldn't process template: " . $tmpl->error );
        return $output;
    }
    
    # Not being called by old WebGUI
    return $self->$orig(@args);
};

sub www_editSave {
    my ( $self, @args ) = @_;

    # This will only get called when adding an old WebGUI asset to a WebGUIx asset
    # XXX: Implement this...
}

1;
