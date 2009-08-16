#!/usr/bin/env perl

use strict;
use warnings;
use lib "lib";

use WebGUIx::Asset::Schema;
use WebGUI::Session;

my $session = WebGUI::Session->open( '/data/WebGUI', 'svn.conf' );

my $assets = WebGUIx::Asset::Schema->connect( sub { $session->db->dbh } );

my $snippet 
    = $assets->resultset('Snippet')->create({
        session     => $session,
    });

