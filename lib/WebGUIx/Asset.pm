package WebGUIx::Asset;

use Carp qw( croak );

# The common methods that everyone needs

#sub can_add { ... }
#sub can_edit { ... }
#sub can_view { ... }
#sub cut { ... }
#sub duplicate { ... }
#sub get_container_asset { ... }
#sub get_edit_form { ... }
#sub get_last_modified { ... }
#sub get_lineage { ... }
#sub get_parent { ... }
#sub get_template_vars { ... }
#sub get_toolbar { ... }
#sub get_uilevel { ... }
#sub get_url { ... }
#sub has_children { ... }
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

#sub paste { ... }
#sub process_edit_form { ... }
#sub process_style { ... }
#sub publish { ... }
#sub purge { ... }
#sub purge_cache { ... }

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
#sub www_add_save { ... }
#sub www_change_url { ... }
#sub www_change_url_save { ... }
#sub www_copy { ... }
#sub www_cut { ... }
#sub www_edit { ... }
#sub www_edit_save { ... }
#sub www_paste { ... }
#sub www_purge_revision { ... }
#sub www_trash { ... } 
#sub www_view { ... }

1;

