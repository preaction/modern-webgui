package WebGUIx::Model;

# Base class for all WebGUI models

use Moose;
use MooseX::Declare;
use WebGUIx::Field;
use WebGUIx::Form;
use WebGUIx::Meta::Attribute::Trait::DB;
use WebGUIx::Meta::Attribute::Trait::Form;
use Carp qw(confess);

extends qw{ DBIx::Class };

__PACKAGE__->load_components(qw{ Core });

=head1 NAME

WebGUIx::Model -- Base class for WebGUIx database tables

=head1 SYNOPSIS

 package MyApp::Model::MyModel;

 use Moose;
 extends qw{ WebGUIx::Model };

 has 'name' => (
    is      => 'rw',
    isa     => 'Str',
    traits  => [qw{ DB Form }],
 );

 has 'amount' => (
    is      => 'rw',
    isa     => 'Num',
    traits  => [qw{ DB }],      # Not shown in edit form
 );

 __PACKAGE__->table( 'MyModel' );
 __PACKAGE__->add_relationship( ... );

 __PACKAGE__->meta->make_immutable;

 # Add your methods
 
 1;

=head1 DESCRIPTION

WebGUIx::Model is the base class for all WebGUIx database tables. 

Inherited from DBIx::Class and Moose, it describes attributes and relationships
and provides methods to easily work with models from the rest of WebGUIx.

WebGUIx::Models are not directly accessible from the web and do not have URLs. 
For that, you should use L<WebGUIx::Asset>, a subclass of WebGUIx::Model.

=head1 ATTRIBUTES

Attributes are defined in the standard Moose way. All Moose attributes must 
be defined before the call to table(), to ensure they are added as columns to
DBIx::Class.

=head2 TRAITS

Traits are used to denote which attributes should be database columns and which
should be available through get_edit_form().

=over 4

=item DB

An attribute that should be stored in the database. 

=item Form

An attribute that should be shown in the edit form.

=back

=head1 METHODS

#----------------------------------------------------------------------------

=head2 get_edit_form ( )

Get the WebGUIx::Form object to edit this model. 

You will need to fill in an action and handle processing yourself.

=cut

sub get_edit_form {
    my ( $self ) = @_;
    
    if ( !$self->session ) {
        confess "I don't have a session!";
    }

    my $form    = WebGUIx::Form->new( session => $self->session );
   
    no warnings qw{ uninitialized };
    my @attrs   = sort { $a->form->{order} <=> $b->form->{order} }
                  grep { $_->does('WebGUIx::Meta::Attribute::Trait::Form') }
                  $self->meta->get_all_attributes
                  ;
    use warnings qw{ uninitialized };

    for my $attr ( @attrs ) {
        my $class   = $attr->form->{field};
        my $name    = $attr->name;
        my %params  =  
            map { $_ => $attr->form->{$_} } 
            grep { $_ ne 'field' && $_ ne 'tab' }
            keys %{ $attr->form }
            ;
        $params{ name   } = $name;
        # XXX: MooseX::Method::Signatures has problems with undef in a 
        # hash, so disallow undef in default value
        $params{ value  } = $self->$name || ''; 
        if ( $attr->form->{tab} ) {
            my $tab_name    = $attr->form->{tab};
            if ( !$form->get_tab( $tab_name ) ) {
                $form->add_tab( name => $tab_name );
            }
            $form->get_tab($tab_name)->add_field(
                $class, %params,
            );
        }
        else {
            $form->add_field( $class, %params );
        }
    }

    return $form;
}

#----------------------------------------------------------------------------

sub session {
    my ( $self ) = @_;
    return $self->result_source->schema->session;
}

#----------------------------------------------------------------------------

=head2 table ( table_name )

Set the table name for this model. This must be done AFTER all attributes are
added.

=cut

sub table {
    my ( $class, $table ) = @_;

    # Assign the table through DBIx::Class
    $class->next::method( $table );

    # Add any moose properties
    my $meta        = $class->meta;
    my @primary_key = ();
    for my $attr ( $meta->get_all_attributes ) {
        if ( $attr->does('WebGUIx::Meta::Attribute::Trait::DB') ) {
            $class->add_column( $attr->name => {
                default_value   => $attr->default,   
            });
            if ( $attr->db && $attr->db->{primary_key} ) {
                push @primary_key, $attr->name;
            }
        }
        else {
            warn "$class adding " . $attr->name;
            $class->mk_group_accessors( simple => $attr->name );
        }
    } 
    if ( @primary_key ) {
        $class->set_primary_key( @primary_key );
    }
}


1;
