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
    },
);

has 'mimeType' => (
    is      => 'rw',
    isa     => 'Str',
    traits  => [qw{ DB Form }],
    default => 'text/plain',
    form    => {
        field       => 'Text',
    },
);

has 'cacheTimeout' => (
    is      => 'rw',
    isa     => 'Int',
    traits  => [qw{ DB Form }],
    default => 0,
    form    => {
        field       => 'Text',
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
    },
);

__PACKAGE__->table( 'RawContent' );

# CREATE TABLE RawContent ( 
#   assetId CHAR(22) BINARY NOT NULL, 
#   revisionDate BIGINT, 
#   content LONGTEXT, 
#   contentPacked LONGTEXT, 
#   mimeType CHAR(100), 
#   cacheTimeout BIGINT, 
#   usePacked BIT, 
#   PRIMARY KEY (assetId, revisionDate) 
# );

#------------------------------------------------------------------

sub www_view {
    my ( $self ) = @_;
    return $self->content;
    return $self->usePacked ? $self->contentPacked : $self->content;
}

1;

