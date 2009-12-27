#!/usr/bin/env perl

BEGIN {
    $ENV{DBIC_MULTICREATE_DEBUG} = 1;
    use strict;
    use warnings;
    use lib "lib", "/data/WebGUI/lib";
    require 'WebGUIx/Asset/Schema.pm';
    use WebGUI::Session;
}



my $session = WebGUI::Session->open( '/data/WebGUI', 'core.conf' );

my $schema = WebGUIx::Asset::Schema->connect( sub { $session->db->dbh } );
$session->{_schema} = $schema;

my $new = WebGUIx::Asset::RawContent->newByPropertyHashRef( $session, {
    content     => 'This is some content',
    url         => 'rawcontent',
    status      => 'approved',
});

print $new->tree->parentId;

$new = $new->addRevision( {
    
}, time + 1 );

print $new->tree->parentId;
