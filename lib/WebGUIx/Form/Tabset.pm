package WebGUIx::Form::Tabset;

use Moose;
use WebGUIx::Form::Tab;

has 'name' => (
    is      => 'rw',
    isa     => 'Str',
);

has 'tabs' => (
    is      => 'rw',
    isa     => 'ArrayRef[WebGUIx::Form::Tab]',
    default => sub { [] },
);

has 'session' => (
    is          => 'ro',
    isa         => 'WebGUI::Session',
    required    => 1,
);

sub add_tab {
    my ( $self, @args ) = @_;
    my $tab;

    if ( scalar @args == 1 && $args[0]->isa( 'WebGUIx::Form::Tab' ) ) {
        $tab = $args[0];
    }
    else {
        push @args, session => $self->session;
        $tab = WebGUIx::Form::Tab->new( @args );
    }

    push @{$self->tabs}, $tab;
    $self->{_tabsByName}{$tab->name} = $tab;
    return $tab;
}

sub combine {
    my ( $self, $tabset ) = @_;
    
    for my $tab ( @{ $tabset->tabs } ) {
        if ( my $self_tab = $self->get_tab( $tab->name ) ) {
            $self_tab->combine( $tab );
        }
        else {
            $self->add_tab( $tab );
        }
    }
}

sub get_tab {
    my ( $self, $tab_name ) = @_;
    return $self->{_tabsByName}{$tab_name};
}

sub process {
    my ( $self, $session ) = @_;
    my %var = ();
    for my $tab ( @{$self->tabs} ) {
        %var = ( %var, %{$tab->process} );
    }
    return \%var;
}

sub print {
    my ( $self ) = @_;
    
    my $tmpl    = WebGUIx::Template::File->new( 
        session => $self->session,
        file    => 'form/tabset.html',
    );
    $tmpl->tt_options->{ INCLUDE_PATH } = '/data/modern-webgui/tmpl'; # XXX: In config
    $tmpl->var->{ tabset } = {
        name        => $self->name,
        tabs        => $self->tabs,
    };

    my $html    = '';
    $tmpl->process( \$html );
    return $html;
}

1;
