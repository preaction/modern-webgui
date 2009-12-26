package WebGUIx::Form::Role::HasTabsets;

use Moose::Role;
use WebGUIx::Form::Tabset;

with 'WebGUIx::Form::Role::HasObjects';
requires 'session';

has 'tabsets' => (
    is      => 'rw',
    isa     => 'HashRef[WebGUIx::Form::Tabset]',
    default => sub { {} },
);

sub add_tab {
    my ( $self, %params ) = @_;
    my $tabset_name = delete $params{tabset} || "default";
    my $tabset  = $self->tabsets->{ $tabset_name };
    if ( !$tabset ) {
        $tabset = $self->add_tabset( name => $tabset_name );
    }
    return $tabset->add_tab( %params );
}

sub add_tabset {
    my ( $self, @args ) = @_;
    my $tabset;

    if ( scalar @args == 1 ) {
        $tabset = $args[0];
    }
    else {
        push @args, session => $self->session;
        $tabset = WebGUIx::Form::Tabset->new( @args );
    }

    push @{$self->objects}, $tabset;
    $self->tabsets->{ $tabset->name } = $tabset;
    return $tabset;
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
