package WebGUIx::Asset::Any;

use Moose;
extends qw{ WebGUIx::Model };

has 'assetId' => (
    traits  => [qw/ DB /],
    is      => 'ro',
    isa     => 'Str',
    db      => {
        primary_key     => 1,
        size            => 22,
    },
);

has 'revisionDate' => (
    traits  => [qw/ DB /],
    is      => 'ro',
    isa     => 'Int',
    db      => {
        primary_key     => 1,
    },
);

has 'title' => (
    traits  => [qw/ DB Form /],
    is      => 'rw',
    isa     => 'Str',
    form    => {
        field       => 'Text',
        tab         => 'properties',
    },
);

has 'menuTitle' => (
    traits  => [qw/ DB Form /],
    is      => 'rw',
    isa     => 'Str',
    form    => {
        field       => 'Text',
        tab         => 'properties',
    },
);

has 'url' => (
    traits      => [qw/ DB Form /],
    is          => 'rw',
    isa         => 'Str',
    form        => {
        field       => 'Text',
        tab         => 'properties',
    },
);

has 'groupIdView' => (
    traits      => [qw/ DB Form /],
    is          => 'rw',
    isa         => 'Str',
    db          => {
        size        => 22,
    },
    form        => {
        field       => 'Group',
        tab         => 'security',
    },
);

has 'groupIdEdit' => (
    traits      => [qw/ DB Form /],
    is          => 'rw',
    isa         => 'Str',
    db          => {
        size        => 22,
    },
    form        => {
        field       => 'Group',
        tab         => 'security',
    },
);

has 'synopsis' => (
    traits      => [qw/ DB Form /],
    is          => 'rw',
    isa         => 'Str',
    form        => {
        field       => 'Textarea',
        tab         => 'metadata',
    },
);

has 'ownerUserId' => (
    traits      => [qw/ DB Form /],
    is          => 'rw',
    isa         => 'Str',
    db          => {
        size        => 22,
    },
    form        => {
        field       => 'User',
        tab         => 'security',
    },
);

has 'status' => (
    traits      => [qw/ DB /],
    is          => 'rw',
    isa         => 'Str',
);

has 'tagId' => (
    traits      => [qw/ DB /],
    is          => 'rw',
    isa         => 'Str',
    db          => {
        size        => 22,
    },
);

has 'revisedBy' => (
    traits      => [qw/ DB /],
    is          => 'rw',
    isa         => 'Str',
    db          => {
        size        => 22,
    },
);

__PACKAGE__->table( 'assetData' );
__PACKAGE__->belongs_to(
    'tree' => 'WebGUIx::Asset::Tree',
    { 
        'foreign.assetId' => 'self.assetId'
    },
);

#----------------------------------------------------------------------------

=head2 as_asset ( )

Return the result as the WebGUIx::Asset subtype.

=cut

sub as_asset {
    my ( $self ) = @_;
    my ( $src ) = $self->tree->className =~ m/([^:]+)$/;
    return $self->result_source->schema->resultset( $src )->find({
        assetId         => $self->assetId,
        revisionDate    => $self->revisionDate,
        },
    );
}

1;
