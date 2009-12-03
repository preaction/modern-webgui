package WebGUIx::Model;

# Base class for all WebGUI models

use Moose;
use MooseX::Declare;
use WebGUIx::Field;
use WebGUIx::Form;
use WebGUIx::Meta::Attribute::Trait::DB;
use WebGUIx::Meta::Attribute::Trait::Form;

extends qw{ DBIx::Class };

__PACKAGE__->load_components(qw{ VirtualColumns Core });

sub get_edit_form {
    my ( $self ) = @_;
    my $form    = WebGUIx::Form->new;
    
    for my $attr ( $self->meta->get_all_attributes ) {
        if ( $attr->does('WebGUIx::Meta::Attribute::Trait::Form') ) {
            my $class   = $attr->form->{field};
            my %params  =  
                map { $_ => $attr->form->{$_} } 
                grep { $_ ne 'field' }
                keys %{ $attr->form }
                ;
            $params{name} = $attr->name;
            $form->add_field( $class, %params );
        }
    }

    return $form;
}

sub table {
    my ( $class, $table ) = @_;

    $class->next::method( $table );

    # Add any moose properties
    my $meta        = $class->meta;
    my @primary_key = ();
    for my $attr ( $meta->get_all_attributes ) {
        if ( $attr->does('WebGUIx::Meta::Attribute::Trait::DB') ) {
            $class->add_column( $attr->name );
            if ( $attr->db && $attr->db->{primary_key} ) {
                push @primary_key, $attr->name;
            }
        }
        else {
            $class->add_virtual_column( $attr->name );
        }
    } 
    if ( @primary_key ) {
        $class->set_primary_key( @primary_key );
    }
}


1;
