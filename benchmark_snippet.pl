
use strict;
use warnings;
use Benchmark;

use WebGUI::Asset;
use WebGUIx::Asset::Schema;
use WebGUI::Test;

my $session = WebGUI::Test->session;
my $schema  = WebGUIx::Asset::Schema->connect( sub{ $session->db->dbh } );

timethese( 10_000, {
    "WebGUI" => sub { 
        my $asset   = WebGUI::Asset->newByDynamicClass( $session, "3n3H85BsdeRQ0I08WmvlOg" );
    },
    "WebGUIx" => sub {
        my $asset   = $schema->resultset('Any')->find({ assetId => "3n3H85BsdeRQ0I08WmvlOg" } )
                    ->as_asset;
    },
});

