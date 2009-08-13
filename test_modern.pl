#!/usr/bin/env perl

use strict;
use warnings;
use lib "lib";

use WebGUIx::Asset::Schema;

my $assets = WebGUIx::Asset::Schema->connect( 
    'dbi:mysql:svn', 'root', 'nasty1' 
);

my $snippet 
    = $assets->resultset('Snippet')->find({
        assetId         => "kwTL1SWCk0GlpiJ5zAAEPQ",
        revisionDate    => 1244488512,
    });

print $snippet->data->title . "\n";

#my $new = $snippet->add_revision;
#print $new->data->title . " (" . $new->revisionDate . ") \n";

for my $r ( $snippet->get_all_revisions ) {
    print $r->title . " (" . $r->revisionDate . ") \n";
}
