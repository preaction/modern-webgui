package WebGUIx::Template;

# Base class for templates

use Moose;
use Template;

has 'forms' => (
    is      => 'rw',
    isa     => 'ArrayRef[WebGUIx::Form]',
    traits  => ['Array'],
    default => sub { [] },
    handles => {
        add_form    => 'push',
    },
);

has 'var' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
);

has 'tt_options' => (
    is          => 'ro',
    isa         => 'HashRef',
    default     => sub { {} },
);

has 'tt' => (
    is          => 'ro',
    isa         => 'Template',
    required    => 1,
    lazy        => 1,
    default     => sub { 
        return Template->new( %{shift->tt_options} );
    },
    handles     => [ 'error', ],
);

sub process {
    my ( $self, @args ) = @_;
    my %var = %{$self->var};
    for my $form ( @{$self->forms} ) {
        $var{forms}{$form->name} = $form;
    }
    return $self->tt->process( $self->get_template, \%var, @args )
        || confess( "Could not process template: " . $self->tt->error );
}

1;
