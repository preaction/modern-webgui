package WebGUIx::View;


# Generic views to be used with WebGUIx::Models
#

=head1 views

#----------------------------------------------------------------------------

=head2 edit

Display a form to edit a WebGUIx::Model

=head3 options

=over 4

=item relationships

Add a way to also edit related things

=back

=cut

sub edit {
    my ( $class, $self, %options ) = @_;

    if ( $options{relationships} && $self->result_source->relationships ) {

    }
    
    return $tmpl;
}

#----------------------------------------------------------------------------

=head2 list

Display a list of WebGUIx::Models

=head3 options

=over 4

=item class

The class of model to list

=item per_page

The number of items to show per page

=item query

Limit the results listed. A hashref of column => value suitable to be passed
to DBIx::Class::ResultSet->search()

=item template_id

The ID for a WebGUIx::Asset::Template to compose the view.

=back

=cut

sub list {
    my ( $self, $options ) = @_;

    my $template = $self->schema->resultset('Template')
                    ->find({ assetId => $options->{template_id} } )
                    ->as_asset;

    my $rs      = $self->schema->resultset( $options->{class} )
                    ->search( $options->{query} );
    
    return $template->process( { $self->get_template_vars, list => $rs } );
}

#----------------------------------------------------------------------------

=head2 single ( object, options )

Display a single WebGUIx::Model

=head3 options

=over 4

=item template_id

The ID of a WebGUIx::Asset::Template to compose the results

=back

=cut

sub single {
    my ( $self, $options ) = @_;
    
    my $template = $self->schema->resultset('Template')
                    ->find({ assetId => $options->{template_id} } )
                    ->as_asset;

    return $template->process( $self->get_template_vars );
}

1;
