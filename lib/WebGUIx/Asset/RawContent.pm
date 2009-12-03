package WebGUIx::Asset::RawContent;

use Moose;
extends qw{ WebGUIx::Asset };
with 'WebGUIx::Asset::Role::Versioning';
with 'WebGUIx::Asset::Role::Compatible';

__PACKAGE__->table( 'RawContent' );
__PACKAGE__->add_columns(qw{ 
    content mimeType cacheTimeout
    contentPacked usePacked
});

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

