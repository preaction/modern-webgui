package WebGUIx::Form;

# Build and manipulate forms to be given to views

use Moose;

with 'WebGUIx::Form::Role::HasFields';
with 'WebGUIx::Form::Role::HasTabsets';
with 'WebGUIx::Form::Role::HasFieldsets';

has 'name' => (
    is      => 'rw',
    isa     => 'Str',
);

has 'action' => (
    is      => 'rw',
    isa     => 'Str',
);

has 'method' => (
    is      => 'rw',
    isa     => 'Str',
    default => 'post',
);

has 'enctype' => (
    is      => 'rw',
    isa     => 'Str',
    default => 'multipart/form-data',
);

# More HTML attributes

sub print {
    my ( $self ) = @_;
    my @html_attrs = qw(
        name action method enctype
    );
    my $html
        = sprintf( '<form %s>', 
            join " ", map { $_ . q{="} . $self->$_ . q{"} } grep { $self->$_ } @html_attrs 
        )
        . $self->print_objects
        . '</form>'
        ;
    return $html;
}

1;
