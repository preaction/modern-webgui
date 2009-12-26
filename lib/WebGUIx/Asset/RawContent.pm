package WebGUIx::Asset::RawContent;

use Moose;
extends qw{ WebGUIx::Asset };
with 'WebGUIx::Asset::Role::Versioning';
with 'WebGUIx::Asset::Role::Compatible';

has 'content' => (
    is      => 'rw',
    isa     => 'Str',
    traits  => [qw{ DB Form }],
    form    => {
        field       => 'Textarea',
        tab         => 'properties',
    },
);

has 'mimeType' => (
    is      => 'rw',
    isa     => 'Str',
    traits  => [qw{ DB Form }],
    default => 'text/plain',
    form    => {
        field       => 'Text',
        tab         => 'properties',
    },
);

has 'cacheTimeout' => (
    is      => 'rw',
    isa     => 'Int',
    traits  => [qw{ DB Form }],
    default => 0,
    form    => {
        field       => 'Text',
        tab         => 'properties',
    },
);

has 'contentPacked' => (
    is      => 'rw',
    isa     => 'Str',
    traits  => [qw{ DB }],
);

has 'usePacked' => (
    is      => 'rw',
    isa     => 'Bool',
    traits  => [qw{ DB Form }],
    form    => {
        field       => 'Boolean',
        tab         => 'properties',
    },
);

__PACKAGE__->table( 'RawContent' );

#------------------------------------------------------------------

sub www_view {
    my ( $self ) = @_;
    return $self->content;
    return $self->usePacked ? $self->contentPacked : $self->content;
}

1;

