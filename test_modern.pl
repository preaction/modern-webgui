#!/usr/bin/env perl

use strict;
use warnings;
use lib "lib";

use WebGUIx::Asset::Schema;
use WebGUI::Session;

my $session = WebGUI::Session->open( '/data/WebGUI', 'core.conf' );

my $assets = WebGUIx::Asset::Schema->connect( sub { $session->db->dbh } );

my $raw 
    = $assets->resultset('RawContent')->create({
        session     => $session,
        content     => 'This is some content',
        data        => {
            url         => 'my-new-url',
        },
    });


