package WebGUIx::Asset::Snippet;

use Moose;
extends qw{ WebGUIx::Asset };
with 'WebGUIx::Asset::Role::Versioning';

__PACKAGE__->table( 'snippet' );
__PACKAGE__->add_columns(qw{ 
    snippet processAsTemplate mimeType cacheTimeout
    snippetPacked usePacked
});

#------------------------------------------------------------------
# Snippet-specific methods


1;

