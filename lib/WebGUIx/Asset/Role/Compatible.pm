package WebGUIx::Asset::Role::Compatible;

# Compatibility with existing WebGUI API

use Moose::Role;

with 'WebGUIx::Asset::Role::Versioning';

sub _caller_is_old {
    my $i = 1;
    while ( my ( $package, @ignore ) = caller( $i ) ) {
        return 1 if $package =~ "^WebGUI::";
        $i++;
    }
    return 0;
}

sub addRevision {
    my ( $self, $properties, $revisionDate, $options ) = @_;
    delete $properties->{tree};    # Why does this appear here? 

    if ( $revisionDate ) {
        $properties->{revisionDate} = $revisionDate;
    }

    for my $attr ( WebGUIx::Asset::Any->meta->get_all_attributes ) {
        if ( $properties->{ $attr->name } ) {
            $properties->{ data }{ $attr->name } = delete $properties->{ $attr->name };
        }
    }

    $self->session->log->warn( "SESSION ISA " . ref $self->session );

    # Otherwise add a new revision
    return $self->add_revision( %{$properties} );
}

sub canAdd {
    my ( $class, @args ) = @_;
    return $class->can_add( @args );
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

sub getAutoCommitWorkflowId {
    return '';
}

sub getChildCount {
    my ( $self ) = @_;
    return $self->get_children->count;
}

sub getContainer {
    my ( $self ) = @_;
    my $tree = $self->get_container;
    if ( $tree->className->isa('WebGUIx::Asset') ) {
        return $tree->as_asset;
    }
    else {
        return WebGUI::Asset->newByDynamicClass( $self->session, $tree->assetId );
    }
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

sub getTitle {
    my ( $self ) = @_;
    # Only called by AdminBar
    my $title   = ref $self;
    $title =~ m/::([^:]+)$/;
    return $self->data->title || $1;
}

sub getUiLevel {
    return 1;
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
    if ( _caller_is_old() && ref $args[0] eq 'WebGUI::Session' ) {
        my ( $session, $assetId, $className, $revisionDate ) = @args;

        use Carp qw(longmess);
        $session->log->info( "Called by: " . longmess() );

        my $schema;
        unless ( $schema = $session->{_schema} ) {
            $schema = $session->{_schema} 
                    = WebGUIx::Asset::Schema->connect( sub { $session->db->dbh } );
        }
        
        $revisionDate    ||= $class->get_current_revision_date( $session, $assetId );

        my $row     = $schema->resultset('Any')->find({
            assetId         => $assetId,
            revisionDate    => $revisionDate,
        });
        my $asset   = $row->as_asset;
        return $asset;
    }

    # Not being called by old WebGUI
    return $class->$orig(@args);
};

sub newByPropertyHashRef {
    my ( $class, $session, $hashref ) = @_;
    delete $hashref->{dummy}; # accurate description
    delete $hashref->{styleTemplateId}; # Not gonna be called this...
    delete $hashref->{encryptPage}; # XXX: Add later
    delete $hashref->{printableStyleTemplateId};
    delete $hashref->{isHidden}; # XXX: Add later

    use Data::Dumper; use Carp qw( longmess );
    $session->log->warn( "HASHREF: " . Dumper $hashref );
    $session->log->warn( "FROM: " . longmess );

    # Fix the hashref
    $hashref->{ data } = {};
    for my $attr ( WebGUIx::Asset::Any->meta->get_all_attributes ) {
        if ( $hashref->{ $attr->name } ) {
            $hashref->{ data }{ $attr->name } = delete $hashref->{ $attr->name };
        }
    }
    $hashref->{ tree } = {
        className       => $class,
    };
    for my $attr ( WebGUIx::Asset::Tree->meta->get_all_attributes ) {
        if ( $hashref->{ $attr->name } ) {
            $hashref->{ tree }{ $attr->name } = delete $hashref->{ $attr->name };
        }
    }

    my $schema;
    unless ( $schema = $session->{_schema} ) {
        $schema = $session->{_schema} 
                = WebGUIx::Asset::Schema->connect( sub { $session->db->dbh } );
    }
    my $asset = $session->{_schema}->resultset($class)->new({ 
        %{ $hashref },
    });

    $session->log->warn( "SESSION ISA " . ref $session );

    return $asset;
}

sub processPropertiesFromFormPost {
    my ( $self ) = @_;

    $self->session->log->warn( "MY SESSION ISA " . ref $self->session );
    # WebGUI processes the form AND saves to the database
    $self->process_edit_form;
    if ( !$self->in_storage ) {
        $self->insert;
        $self->tree->insert;
    }
    else {
        $self->update;
    }

    return;
}

sub updateHistory {
    my ( $self, @args ) = @_;
    return;
}

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

            # Fix fields
            $tmpl->forms->[0]->fields->{func}->value( "editSave" );
            my $class   = $tmpl->forms->[0]->fields->{className}->value;
            $tmpl->forms->[0]->add_field( 'Hidden', name => 'class', value => $class );
            $tmpl->forms->[0]->action( $self->session->url->page );
            $tmpl->forms->[0]->get_tab('metadata')->fields->{assetId}->value( "new" );
            $tmpl->forms->[0]->add_field( 'Hidden', name => 'assetId', value => "new" );

            # Add CSRF token
            $tmpl->forms->[0]->add_field( 'Hidden', 
                name => 'webguiCsrfToken', 
                value => $self->session->scratch->get('webguiCsrfToken'),
            );

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

around www_add_save => sub {
    my ( $orig, $self, @args ) = @_;
    
    my $tmpl    = $self->$orig( @args );

    if ( _caller_is_old() ) {
        # XXX: This needs to be in config file
        $tmpl->tt_options->{INCLUDE_PATH} = "/data/modern-webgui/tmpl"; 
        my $output = '';
        $tmpl->process(\$output)
        || $self->session->log->error("Couldn't process template: " . $tmpl->error );
        return $output;
    }

    return $tmpl;
};

around www_edit => sub {
    my ( $orig, $self, @args ) = @_;
    
    # Being called by old WebGUI
    if ( _caller_is_old() ) {
        my $tmpl;
        if ( $self->session->form->get('func') eq "add" ) {
            return $self->www_add( @args );
        }
        else {
            $tmpl = $self->$orig( @args );
        }

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

    my $class   = $self->session->form->get('class');

    # Are we adding an old WebGUI asset to a WebGUIx one?
    if ( $class->isa( 'WebGUI::Asset' ) ) {
        # XXX: Implement this
    }
    # Or are we adding a WebGUIx asset to an old WebGUI one
    elsif ( $class->isa( 'WebGUIx::Asset' ) ) {
        return $self->www_add_save;
    }
}

sub www_view {
    my ( $self, @args ) = @_;
    return $self->view;
}

1;
