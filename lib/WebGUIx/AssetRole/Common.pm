package WebGUIx::AssetRole::Common;

use Moose::Role;
use Carp qw( croak );

# The common methods that everyone needs to make web-facing stuff

#----------------------------------------------------------------------------

=head2 add_revision ( )

Create a new revision of this asset. Returns the object pointing to the new
revision.

=cut


sub add_revision { 
    my ( $self ) = @_;    
    
}

#sub can_add { ... }
#sub can_edit { ... }
#sub can_view { ... }

#----------------------------------------------------------------------------

=head2 commit ( )

Commit this revision. Set status to "approved".

=cut

#sub commit { ... }

#sub get_current_revision_date { ... }
#sub get_edit_form { ... }
#sub get_last_modified { ... }
#sub get_template_vars { ... }
#sub get_toolbar { ... }
#sub get_uilevel { ... }
#sub get_url { ... }
#sub index_content { ... }
#sub log { ... }


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

#----------------------------------------------------------------------------

#sub process_edit_form { ... }
#sub process_style { ... }
#sub publish { ... }
#sub purge { ... }
#sub purge_cache { ... }
#sub purge_revision { ... }

#----------------------------------------------------------------------------

=head2 session ( new_session )

Get or set the WebGUI::Session object attached to this Asset.

=cut

sub session { 
    my ( $self, $session ) = @_;
    if ( $session ) {
        $self->{_session} = $session;
    }
    return $self->{_session} or croak( "No session!" ); # WebGUI::Error::NoSession->throw;
}

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

#sub www_demote { ... }

#sub www_edit { ... }
#sub www_edit_save { ... }

#sub www_paste { ... }
#sub www_promote { ... }

#sub www_purge_revision { ... }

#sub www_set_parent { ... }
#sub www_set_rank { ... }
#sub www_trash { ... } 
#sub www_view { ... }

#sub www_view_revisions { ... }

1;

