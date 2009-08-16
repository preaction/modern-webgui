package WebGUIx::Asset;

use Moose;
extends qw{ DBIx::Class };
use Carp qw( croak );
use WebGUIx::Constant;

# Constants. These should be placed somewhere else later

# The common methods that everyone needs
# You should inherit from this for your own asset
# This class cannot be instanciated

#----------------------------------------------------------------------------

=head2 can_add ( ?user|userId )

Returns true if the user is allowed to add this asset to the current asset. 
The user is allowed to add this asset if they are in the C<addGroup> of the
asset class in this site's configuration file. The user must also pass a 
L<can_edit> check for the current asset. 

The user defaults to the current user if none is provided.

=cut

sub can_add { 
    my ( $self, $user ) = @_;
    
    my $session = $self->session;

    if ( !$user ) {
        # Default to current user
        $user       = $session->user;
    }
    elsif ( !ref $user ) {  
        # Must be a userId
        $user       = WebGUI::User->new( $session, $user );
    }
    
    my $group_id = $session->config->get("assets/" . $self->tree->className . "/addGroup")
                || $WebGUIx::Constant::GROUPID_TURN_ADMIN_ON
                ;

    return $user->isInGroup( $group_id );
}

#----------------------------------------------------------------------------

=head2 can_edit ( ?user|userId )

Returns true if the user is allowed to edit this asset. Users can edit assets
if they are in the group specified by C<groupIdEdit> or if they are the owner
of the asset, specified by C<ownerUserId>.

The user defaults to the current user if none is provided.

=cut

sub can_edit { 
    my ( $self, $user ) = @_;
    my $session = $self->session;

    if ( !$user ) {
        # Default to current user
        $user       = $session->user;
    }
    elsif ( !ref $user ) {  
        # Must be a userId
        $user       = WebGUI::User->new( $session, $user );
    }
    
    return $user->isInGroup( $self->data->groupIdEdit );
}

#----------------------------------------------------------------------------

=head2 can_view ( ?user|userId )

Returns true if the user is allowed to view this asset. Users can view assets
if they are in the C<groupIdView> group or if they are the owner of the asset
specified by C<ownerUserId>.

=cut

sub can_view { 
    my ( $self, $user ) = @_;    
    my $session = $self->session;

    if ( !$user ) {
        # Default to the current user
        $user       = $session->user;
    }
    elsif ( !ref $user ) {
        $user       = WebGUI::User->new( $session, $user );
    }

    return $user->isInGroup( $self->data->groupIdView );
}

#----------------------------------------------------------------------------

=head2 cut ( )

Place the asset on the clipboard by changing state to "clipboard". 

All descendants get the state "clipboard-limbo" so they don't get interfered 
with while their ancestor is on the clipboard.

=cut

sub cut { 
    my ( $self ) = @_;
    
}

#----------------------------------------------------------------------------

=head2 duplicate ( properties )

Create a complete copy of this asset. C<properties> is a hashref of properties
the new copy should have. See L<create()> for the structure of this hashref.

Used as the first step of a "copy" operation, followed by a "cut" of the new
duplicate.

NOTE: DBIx::Class::Row's copy() method will not propagate into all tables, 
because it needs to be used for versioning.

=cut

sub duplicate {
    my ( $self, $properties ) = @_;

}

#----------------------------------------------------------------------------

=head2 get_children ( options )

Get the children of this asset. C<options> is a hashref with the following
keys.

 ...

=cut

sub get_children {
    my ( $self, $options ) = @_;

}

#----------------------------------------------------------------------------

=head2 get_container ( )

Get the container for this asset. The container is the ancestor that is the
entry point to this asset. It is used for two purposes:

 1) To bring the user in from a search
 2) To return the user after a delete, cut, promote, or demote

Example: An Article on a Layout, the container is the Layout.
Example: A Post in a Thread in a Forum, the container is the Forum.

Defaults to the asset's parent.

=cut

sub get_container {
    my ( $self ) = @_;
    return $self->get_parent;
}

#----------------------------------------------------------------------------

#sub get_edit_form { ... }

#----------------------------------------------------------------------------

=head2 get_last_modified ( )

Get the time this asset was last modified for browser cache purposes. Some
assets may want to return 0 to make sure their content is never cached.

Defaults to the C<revisionDate>

=cut

sub get_last_modified {
    my ( $self ) = @_;
    return $self->revisionDate;
}

#----------------------------------------------------------------------------
#sub get_lineage { ... }
#----------------------------------------------------------------------------

=head2 get_parent ( )

Get the parent asset.

=cut

sub get_parent { 
    my ( $self ) = @_;
    return $self->result_source->schema->resultset('Any')->find({
        assetId => $self->tree->parentId,
    });
}

#----------------------------------------------------------------------------
#sub get_template_vars { ... }
#----------------------------------------------------------------------------
#sub get_toolbar { ... }
#----------------------------------------------------------------------------

=head2 get_url ( params )

Get an absolute URL to this asset. C<params> is a hashref of URL parameters
to add to the URL.

This is different from the C<url> property because it includes the site's 
gateway. If you want a full URL with schema and domain name, use
get_url_full().

=cut

sub get_url {
    my ( $self, $params ) = @_;
    

}

#----------------------------------------------------------------------------

=head2 get_url_full ( params )

Get the full URL to this asset. C<params> is a hashref of URL parameters
to add to the URL.

This is different from the C<url> property because it includes the URL 
schema, domain name, and site gateway. This should only be used when creating
URLs to send out via e-mail or RSS or etc...

=cut

sub get_url_full {
    my ( $self, $params ) = @_;
    

}

#----------------------------------------------------------------------------
#sub has_children { ... }
#----------------------------------------------------------------------------

=head2 log ( action, message )

Add an entry to the asset history log. C<action> is what the user is doing. 
C<message> is more details, such as which fields were edited, or why the
action is happening.

=cut

#sub log { ... }

#----------------------------------------------------------------------------

=head2 new ( )

Create or instanciate a new asset. If the asset cannot be instanciated, will
croak.

=cut

sub new {
    my ( $class, $attr ) = @_;
    my $session = $attr->{session};

    # Autogenerate missing properties
    $attr->{ assetId                } ||= $session->id->generate;
    $attr->{ revisionDate           } ||= time;
    $attr->{ tree }{ assetId        } = $attr->{ assetId };
    $attr->{ tree }{ parentId       } ||= $WebGUIx::Constant::ASSETID_ROOT;
    $attr->{ tree }{ className      } = $class;
    $attr->{ tree }{ lineage        } = $attr->{ assetId };
    $attr->{ data }{ assetId        } = $attr->{ assetId };
    $attr->{ data }{ revisionDate   } = $attr->{ revisionDate };
    $attr->{ data }{ url            } ||= $attr->{ assetId };
    
    my $self = $class->next::method( $attr );
    
    return $self;
}

#----------------------------------------------------------------------------

=head2 prepare_view ( )

Prepare the template to be used in the L<view()> method. This allows us to do
as much as possible before the hard work of L<view()>. Returns a reference to 
a L<WebGUIx::Asset::Template> object.

=cut

sub prepare_view { 
    my ( $self ) = @_;    
    
    my $template_id = $self->template_id_view;

    # XXX
}

#sub paste { ... }
#----------------------------------------------------------------------------
#sub process_edit_form { ... }
#----------------------------------------------------------------------------
#sub process_style { ... }
#----------------------------------------------------------------------------
#sub publish { ... }
#----------------------------------------------------------------------------
#sub purge { ... }
#----------------------------------------------------------------------------
#sub purge_cache { ... }

#----------------------------------------------------------------------------

=head2 schema ( )

Get a connected WebGUIx::Asset::Schema.

=cut

sub schema {
    my ( $self ) = @_;
    if ( !$self->{_schema} ) {
        $self->{_schema}
            = WebGUIx::Asset::Schema->connect( sub { $self->session->db->dbh } );
    }
    return $self->{_schema};
}

#----------------------------------------------------------------------------

=head2 session ( new_session )

Get or set the WebGUI::Session object attached to this Asset.

=cut

#----------------------------------------------------------------------------

=head2 view ( options )

Get the default view for this asset's content. Does not include the style
wrapper. Uses the template prepared by L<prepare_view()>. C<options> is a 
hashref of options that can be used by subclasses. Returns a 
L<WebGUIx::Asset::Template> with the default set of template variables.

Some default options:

    error       => An error message to show the user that something is wrong
    warning     => A warning to show the user that something may be wrong
    message     => An informational message to show the user

=cut

sub view { 
    my ( $self, $options ) = @_;
    my $template        = !$self->{_view_template}
                        ? $self->{_view_template}
                        : $self->prepare_view
                        ;
    

    return $template;
}

#----------------------------------------------------------------------------

#sub www_add { ... }
#----------------------------------------------------------------------------
#sub www_add_save { ... }
#----------------------------------------------------------------------------
#sub www_change_url { ... }
#----------------------------------------------------------------------------
#sub www_change_url_save { ... }
#----------------------------------------------------------------------------
#sub www_copy { ... }
#----------------------------------------------------------------------------
#sub www_cut { ... }
#----------------------------------------------------------------------------
#sub www_edit { ... }
#----------------------------------------------------------------------------
#sub www_edit_save { ... }
#----------------------------------------------------------------------------
#sub www_paste { ... }
#----------------------------------------------------------------------------
#sub www_purge_revision { ... }
#----------------------------------------------------------------------------
#sub www_trash { ... } 
#----------------------------------------------------------------------------
#sub www_view { ... }

1;

