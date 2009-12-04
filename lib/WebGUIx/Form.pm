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

sub foot {
    my ( $self ) = @_;
    return '</form>';
}

sub head {
    my ( $self ) = @_;
    my @html_attrs = qw(
        name action method enctype
    );
    return sprintf( '<form %s>', 
            join " ", map { $_ . q{="} . $self->$_ . q{"} } grep { $self->$_ } @html_attrs 
        );
}

sub print {
    my ( $self ) = @_;
    my $html
        = $self->head
        . $self->print_objects
        . $self->foot
        ;
    return $html;
}

1;
