#!/usr/bin/env perl

use strict;
use warnings;
use lib "lib";

use WebGUIx::Asset;

my $assets = WebGUIx::Asset->connect( 
    'dbi:mysql:svn', 'root', 'nasty1' 
);

my $snippet 
    = $assets->resultset('Snippet')->find({
        assetId         => "kwTL1SWCk0GlpiJ5zAAEPQ",
        revisionDate    => 1244488512,
    });

print $snippet->base->title . "\n";

$snippet->add_revision;
