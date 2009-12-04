#!/usr/bin/env perl

use strict;
use warnings;
use lib "lib";

use WebGUIx::Asset::Schema;
use WebGUI::Session;

my $session = WebGUI::Session->open( '/data/WebGUI', 'core.conf' );

my $schema = WebGUIx::Asset::Schema->connect( sub { $session->db->dbh } );
$session->{schema} = $schema;

my $raw 
    = $schema->resultset('RawContent')->create({
        session     => $session,
        content     => 'This is some content',
        data        => {
            url         => 'rawcontent',
            status      => 'approved',
        },
    });


