package WebGUIx::Form::Role::HasTabsets;

use Moose::Role;
use WebGUIx::Form::Tabset;

with 'WebGUIx::Form::Role::HasObjects';

has 'tabsets' => (
    is      => 'rw',
    isa     => 'HashRef[WebGUIx::Form::Tabset]',
    default => sub { {} },
);

sub add_tab {
    my ( $self, %params ) = @_;
    my $tabset_name = delete $params{tabset} || "default";
    if ( !$self->tabsets->{$tabset_name} ) {
        $self->tabsets->{$tabset_name} 
            = WebGUIx::Form::Tabset->new( name => $tabset_name );
        push @{$self->objects}, $self->tabsets->{$tabset_name};
    }
    return $self->tabsets->{$tabset_name}->add_tab( %params );
}

sub get_tab {
    my ( $self, $tabset_name, $tab_name ) = @_;
    if ( !$tab_name ) {
        $tab_name = $tabset_name;
        $tabset_name = "default";
    }
    return if ( !$self->tabsets->{ $tabset_name } );
    return $self->tabsets->{$tabset_name}->get_tab( $tab_name );
}

1;
