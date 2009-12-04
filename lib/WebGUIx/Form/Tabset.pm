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

sub add_tab {
    my ( $self, %params ) = @_;
    my $tab = WebGUIx::Form::Tab->new( %params );
    push @{$self->tabs}, $tab;
    $self->{_tabsByName}{$tab->name} = $tab;
    return $tab;
}

sub get_tab {
    my ( $self, $tab_name ) = @_;
    return $self->{_tabsByName}{$tab_name};
}

sub process {
    my ( $self, $session ) = @_;
    my %var = ();
    for my $tab ( @{$self->tabs} ) {
        %var = ( %var, %{$tab->process( $session )} );
    }
    return \%var;
}

sub print {
    my ( $self ) = @_;
    
    my $tmpl    = WebGUIx::Template::File->new( file => 'form/tabset.html' );
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
