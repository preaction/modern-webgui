package Modern::WebGUI::Asset::Tree;

use strict;
use warnings;

use Moose;

extends qw{ DBIx::Class };
__PACKAGE__->load_components(qw{ Core });

__PACKAGE__->table( 'asset' );
__PACKAGE__->add_columns(qw{
    assetId className lineage state parentId
});
__PACKAGE__->set_primary_key( 'assetId' );

#------------------------------------------------------------------
# WebGUI API METHODS
# This class handled Lineage, Clipboard, and Trash functions

sub cut { ... }

sub demote_rank { ... }

sub duplicate { ... }

sub get_container_asset { ... }

sub get_lineage { ... }

sub get_parent { ... }

sub get_rank { ... }

sub has_children { ... }

sub paste { ... }

sub promote_rank { ... }

sub set_parent { ... }

sub set_rank { ... }

sub www_copy { ... }
sub www_cut { ... }
sub www_demote { ... }
sub www_paste { ... }
sub www_promote { ... }
sub www_set_parent { ... }
sub www_set_rank { ... }
sub www_trash_clipboard { ... } 
sub www_view_clipboard { ... } 

